require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "MongoMapper::Plugins::ActsAsCommentable" do
  
  before(:each) do
    @commentable = CommentableWithCallback.create()
    @luke = User.create(:email => 'luke@icaruswings.com')
  end

  it "should be commentable" do
    expect(@commentable).to be_commentable
  end

  it "should have a comments_count attribute that defaults to 0" do
     expect(@commentable.comments_count).to be_zero
  end

  describe "add_comment!" do
  
    it "should increment the comments_count attribute" do
      lambda {
        @commentable.add_comment!("first comment", @luke)
        @commentable.reload
      }.should change(@commentable, :comments_count).by(1)    
    end
  
    it "should add the comment" do
      @commentable.add_comment!("first comment", @luke)
      @commentable.reload

      expect(@commentable.comments.size).to be 1
    end
    
    it "should assign the commentor" do
      @commentable.add_comment!("first comment", @luke)
      comment = @commentable.comments.first

      expect(comment.commentor).to equal @luke
    end
    
    it "should call :on_add_vote if the callback has been implemented" do
      expect(@commentable).to receive(:on_add_comment)
      @commentable.add_comment!(1, @luke)
    end
  
  end
  
end

describe "Comment" do
  
  before(:each) do
    @comment = Comment.new
  end
  
  it "should be embeddable?" do
    expect(Comment).to be_embeddable
  end
  
  it "should have a created_at key" do
    expect(@comment).to respond_to(:created_at=)
    expect(@comment).to respond_to(:created_at)
  end
  
  it "should have a commentor association" do
    expect(@comment).to respond_to(:commentor_id=)
    expect(@comment).to respond_to(:commentor_id)
    expect(@comment).to respond_to(:commentor_type=)
    expect(@comment).to respond_to(:commentor_type)

    expect(@comment.associations[:commentor]).to be_a(MongoMapper::Plugins::Associations::BelongsToAssociation)
  end
  
end
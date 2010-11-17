require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "MongoMapper::Plugins::ActsAsCommentable" do
  
  before(:each) do
    @commentable = CommentableWithCallback.create()
    @luke = User.create(:email => 'luke@icaruswings.com')
  end

  it "should be commentable" do
    @commentable.should be_commentable
  end

  it "should have a comments_count attribute that defaults to 0" do
     @commentable.comments_count.should equal 0
  end

  describe "add_vote!" do
  
    it "should increment the comments_count attribute" do
      lambda {
        @commentable.add_comment!("first comment", @luke)
        @commentable.reload
      }.should change(@commentable, :comments_count).by(1)    
    end
  
    it "should add the comment" do
      @commentable.add_comment!("first comment", @luke)
      @commentable.comments.size.should equal 1
    end
    
    it "should assign the commentor" do
      @commentable.add_comment!("first comment", @luke)
      comment = @commentable.comments.first
      comment.commentor_id.should == @luke.id
      comment.commentor_type.should == @luke.class.name
      comment.commentor.should == @luke
    end
    
    it "should throw NotImplementedError if the :on_add_vote callback has not inplemented" do
      commentable = CommentableWithoutCallback.new
      lambda {
        commentable.add_comment!(1, @luke)
      }.should raise_error(NotImplementedError)
    end
    
    it "should call :on_add_vote if the callback has been implemented" do
      @commentable.should_receive(:on_add_comment)
      @commentable.add_comment!(1, @luke)
    end
  
  end
  
end

describe "Comment" do
  
  before(:each) do
    @comment = Comment.new
  end
  
  it "should be embeddable?" do
    Comment.embeddable?.should be_true
  end
  
  it "should be embeddable?" do
    Comment.embeddable?.should be_true
  end
  
  it "should have a created_at key" do
    @comment.should respond_to(:created_at=)
    @comment.should respond_to(:created_at)
  end
  
  it "should have a commentor association" do
    @comment.should respond_to(:commentor_id=)
    @comment.should respond_to(:commentor_id)
    @comment.should respond_to(:commentor_type=)
    @comment.should respond_to(:commentor_type)
    
    @comment.commentor.association.should be_belongs_to
  end
  
end
class Comment
  include MongoMapper::EmbeddedDocument

  after_create :set_created_at
  
  key :body, String, :required => true
  
  key :commentor_id, ObjectId
  key :commentor_type, String
  belongs_to :commentor, :polymorphic => true

  key :created_at, Time  

  embedded_in :commentable
  
  private
  
  def set_created_at
    created_at = Time.now
    save! unless new_record?
  end
end
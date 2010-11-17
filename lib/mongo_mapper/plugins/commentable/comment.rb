class Comment
  include MongoMapper::EmbeddedDocument
  
  key :created_at, Time
  key :body, String, :required => true

  key :commentor_id, ObjectId
  key :commentor_type, String
  belongs_to :commentor, :polymorphic => true

  embedded_in :commentable
end
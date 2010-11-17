class Comment
  include MongoMapper::EmbeddedDocument
  
  key :created_at, Time
  key :body, String, :required => true

  key :commentor_id, ObjectId
  belongs_to :commentor, :class_name => 'User'

  embedded_in :commentable
end
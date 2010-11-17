class CommentableWithCallback
  include MongoMapper::Document
  plugin MongoMapper::Plugins::Commentable  
  
  def on_add_comment(comment)
    true
  end
end

class CommentableWithoutCallback
  include MongoMapper::Document
  plugin MongoMapper::Plugins::Commentable  
end

class User
  include MongoMapper::Document
  key :email, String
end
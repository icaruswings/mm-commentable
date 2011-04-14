require File.join(File.dirname(__FILE__), 'commentable', 'comment')

module MongoMapper
  module Plugins
    module Commentable
      
      extend ActiveSupport::Concern

      included do
        key :comments_count, Integer, :default => 0
        many :comments
      end
      
      module InstanceMethods
        
        def commentable?; true; end

        def add_comment!(comment_body, commentor)
          
          comment = self.comments.build({
            :body => comment_body,
            :commentor => commentor
          })
          
          return false unless comment.save
          
          self.increment('comments_count' => 1)
          on_add_comment(comment)
        end

        def on_add_comment(comment)
          raise NotImplementedError
        end

      end

      module ClassMethods
        
      end
    
    end
  end
end
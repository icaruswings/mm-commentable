require File.join(File.dirname(__FILE__), 'commentable', 'comment')

module MongoMapper
  module Plugins
    module Commentable
      
      def self.configure(model)
        model.class_eval do
          key :comments_count, Integer, :default => 0
          has_many :comments
        
          def commentable?; true; end
        end
      end
      
      module InstanceMethods

        def add_comment!(comment_body, commentor)
          
          comment = self.comments.build({
            :body => comment_body,
            :commentor => commentor,
            :created_at => Time.now
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
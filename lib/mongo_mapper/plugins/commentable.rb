require File.join(File.dirname(__FILE__), 'commentable', 'comment')

module MongoMapper
  module Plugins
    module Commentable
      
      extend ActiveSupport::Concern

      included do
        key :comments_count, Integer, :default => 0
        many :comments
      end
      
      def commentable?; true; end

      def add_comment!(comment_body, commentor)
        
        comment = self.comments.build({
          :body => comment_body,
          :commentor => commentor
        })
        
        return false unless comment.save
        
        increment({ comments_count: 1 })
        on_add_comment(comment) if respond_to? :on_add_comment
      end

      module ClassMethods
      end
    
    end
  end
end
class Comment < ActiveRecord::Base
attr_accessible :title, :body
 belongs_to :commentable, :polymorphic => true
  has_many :comments, :as => :commentable
  has_reputation :votes, source: :user, aggregated_by: :sum

	def mypost
	  return @mypost if defined?(@mypost)
	  @mypost = commentable.is_a?(Mypost) ? commentable : commentable.mypost
	end
end

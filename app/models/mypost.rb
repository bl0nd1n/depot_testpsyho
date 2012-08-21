class Mypost < ActiveRecord::Base
  attr_accessible :content, :image_url, :title, :body, :video_url, :post_url
  belongs_to :user
  has_many :comments, :as => :commentable
  validates :content, presence: true, length: { maximum: 5000 }
  validates :user_id, presence: true
  validates_presence_of :image_url, :unless => :video_url?
  
 # default_scope order: 'myposts.created_at DESC'
   
has_reputation :votes, source: :user, aggregated_by: :sum   
	 
	def comments_count
  comments.count
end 
	 
 def self.from_users_followed_by(user)
    followed_user_ids = "SELECT followed_id FROM relationships
                         WHERE follower_id = :user_id"
    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id", 
          user_id: user.id)
  end
  
def self.from_users(user)
    followed_user_ids = "SELECT user_id FROM microposts
                         WHERE user_id = :user_id"
    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id", 
          user_id: user.id)
  end
  
end

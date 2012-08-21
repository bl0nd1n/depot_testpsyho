class User < ActiveRecord::Base
  attr_accessible :name, :email, :password, :password_confirmation, :title, :body, :avatar
  has_secure_password
  has_many :myposts, dependent: :destroy
  has_many :pinposts, dependent: :destroy
  has_many :microposts, dependent: :destroy
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
  has_many :reverse_relationships, foreign_key: "followed_id",
                                   class_name:  "Relationship",
                                   dependent:   :destroy
  has_many :followers, through: :reverse_relationships, source: :follower,  :order => 'created_at DESC'

  before_save { |user| user.email = email.downcase }
  before_save :create_remember_token

  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }
  validates :password_confirmation, presence: true

  has_reputation :votes, source: {reputation: :votes, of: :myposts}, aggregated_by: :sum
  has_many :evaluations, class_name: "RSEvaluation", as: :source
#scope :popular, all.sort { |a, b| a.followers.count <=> b.followers.count }

def voted_for?(haiku)
  evaluations.where(target_type: haiku.class, target_id: haiku.id).present?
end

def myposts_count
  myposts.count  
end
def comments_count
  comments.count
end

def followers_count
 followers.count
 end

   def feed_me
 Mypost.from_users_followed_by(self)
  end
  
  def feed_all
      Mypost.where(id)
  end
  
  def feed_pin
  Pinpost.where(id)
  end
  
  def feed
    Micropost.from_users_followed_by(self)
  end

  def following?(other_user)
    relationships.find_by_followed_id(other_user.id)
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by_followed_id(other_user.id).destroy
  end

  private

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end

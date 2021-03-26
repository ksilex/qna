class User < ApplicationRecord
  has_many :answers
  has_many :questions
  has_many :rewards
  has_many :votes
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def author?(instance)
    instance.user_id == id
  end

  def upvoted?(resource)
    votes.where(parent: resource, vote_type: :upvote).exists?
  end

  def downvoted?(resource)
    votes.where(parent: resource, vote_type: :downvote).exists?
  end
end

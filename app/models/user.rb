class User < ApplicationRecord
  has_many :answers
  has_many :questions
  has_many :rewards
  has_many :votes
  has_many :subscriptions
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :omniauthable, omniauth_providers: %i[vkontakte github]

  def subscribed?(question)
  subscriptions.find_by(question_id: question.id)
  end

  def self.from_omniauth(auth)
    account = where(provider: auth.provider, uid: auth.uid).first
    return account if account
    return 'has no email' unless auth.info.email

    user = User.new(uid: auth.uid, provider: auth.provider, email: auth.info.email, password: Devise.friendly_token[0, 20])
    user.skip_confirmation!
    user.save
    user
  end

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

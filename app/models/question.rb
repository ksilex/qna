class Question < ApplicationRecord
  include HasVotes

  belongs_to :user
  has_one :reward, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :comments, dependent: :destroy, as: :parent
  has_many :links, dependent: :destroy, as: :parent
  has_many :subscriptions
  has_many :subscribers, through: :subscriptions, source: :user

  accepts_nested_attributes_for :links, reject_if: :all_blank
  accepts_nested_attributes_for :reward, reject_if: :all_blank

  has_many_attached :files

  validates :title, :body, presence: true

  after_commit :subscribe_author

  def subscribe_author
    user.subscriptions.create(question: self)
  end

end

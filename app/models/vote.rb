class Vote < ApplicationRecord
  enum vote_type: %i[downvote upvote]
  belongs_to :user
  belongs_to :parent, polymorphic: true
  validates :vote_type, presence: true
  validate :cant_self_vote
  validate :cant_vote_twice
  after_validation :destroy_previous_decision

  def self.summarize
    where(vote_type: :upvote).size - where(vote_type: :downvote).size
  end

  def destroy_previous_decision
    user&.votes&.find_by(parent: parent)&.destroy
  end

  def cant_vote_twice
    errors.add(:base, 'Can not vote twice') if user&.votes&.where(parent: parent, vote_type: vote_type)&.exists?
  end

  def cant_self_vote
    errors.add(:base, 'No self-voting here') if user&.author?(parent)
  end
end

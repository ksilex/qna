class Vote < ApplicationRecord
  enum vote_type: %i[downvote upvote]
  belongs_to :user
  belongs_to :parent, polymorphic: true
  validate :user_can_vote
  after_validation :destroy_previous_decision

  def self.summarize
    where(vote_type: :upvote).size - where(vote_type: :downvote).size
  end

  def destroy_previous_decision
    user&.votes&.find_by(parent: parent)&.destroy
  end

  def user_can_vote
    errors.add(:base, 'No self-voting here') if user.author?(parent)
  end
end

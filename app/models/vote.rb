class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :parent, polymorphic: true

  validate :user_can_vote

  after_validation :destroy_previous_decision

  enum vote_type: { upvote: 1, downvote: -1 }

  def self.summarize
    values = 0
    all.each { |vote| values += Vote.vote_types[vote.vote_type] }
    values
  end

  def destroy_previous_decision
    user&.votes&.find_by(parent: parent)&.destroy
  end

  def user_can_vote
    errors.add(:base, 'No self-voting here') if user.author?(parent)
  end
end

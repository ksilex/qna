class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :parent, polymorphic: true
  validate :user_can_vote, on: :create
  after_validation :destroy_previous
  enum vote_type: %i[downvote upvote]

  def destroy_previous
    user&.votes&.find_by(parent: parent)&.destroy
  end

  def user_can_vote
    errors.add(:base, "Can't vote") if user.votes.where(parent: parent, vote_type: vote_type).exists? || user.author?(parent)
  end

  def self.summarize
    where(vote_type: :upvote).size - where(vote_type: :downvote).size
  end
end

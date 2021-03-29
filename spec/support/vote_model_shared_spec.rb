require 'rails_helper'

RSpec.shared_examples 'Votes' do
  let(:user) { create(:user) }
  let(:users) { create_list(:user, 4) }
  it 'validates that author can not upvote' do
    vote = model.votes.create(user: model.user, vote_type: :upvote)
    expect(vote).to be_invalid
    expect(vote.errors[:base]).to include("No self-voting here")
  end

  it 'validates that author can not downvote' do
    vote = model.votes.create(user: model.user, vote_type: :downvote)
    expect(vote).to be_invalid
    expect(vote.errors[:base]).to include("No self-voting here")
  end

  it 'validates that user can not vote twice' do
    vote = model.votes.create(user: user, vote_type: :upvote)
    same_vote = model.votes.create(user: user, vote_type: :upvote)
    expect(same_vote).to be_invalid
    expect(same_vote.errors[:base]).to include("Can not vote twice")
  end

  it 'destroys previous decision on vote change' do
    model.votes.create(user: user, vote_type: :upvote)
    model.votes.create(user: user, vote_type: :downvote)
    expect(Vote.count).to eq 1
  end

  it 'sums up upvotes and downvotes' do
    model.votes.create(user: users.first, vote_type: :upvote)
    expect(model.votes.summarize).to eq 1
    model.votes.create(user: users.second, vote_type: :upvote)
    expect(model.votes.summarize).to eq 2
    model.votes.create(user: users.fourth, vote_type: :downvote)
    expect(model.votes.summarize).to eq 1
  end
end
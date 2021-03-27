require 'rails_helper'

RSpec.shared_examples 'VotesController' do
  let(:user) { create(:user) }
  describe 'POST #upvote' do
    context 'as an author' do
      it 'does not saves upvote in database' do
        login(model.user)
        expect { post :upvote, params: { id: model }, format: :json }.to_not change(model.votes, :count)
      end
    end
    context 'as authenticated user' do
      it 'saves upvote in database' do
        login(user)
        post :upvote, params: { id: model }, format: :json
        expect(model.votes.summarize).to eq 1
      end
    end
  end
  describe 'POST #downvote' do
    context 'as an author' do
      it 'does not saves downvote in database' do
        login(model.user)
        expect { post :downvote, params: { id: model }, format: :json }.to_not change(model.votes, :count)
      end
    end
    context 'as authenticated user' do
      it 'saves downvote in database' do
        login(user)
        post :downvote, params: { id: model }, format: :json
        expect(model.votes.summarize).to eq -1
      end
    end
  end

  describe 'DELETE #unvote' do
    it 'destroys downvote in database ' do
      login(user)
      post :downvote, params: { id: model }, format: :json
      expect(model.votes.summarize).to eq -1
      delete :unvote, params: { id: model }, format: :json
      expect(model.votes.summarize).to eq 0
    end
    it 'destroys upvote in database' do
      login(user)
      post :upvote, params: { id: model }, format: :json
      expect(model.votes.summarize).to eq 1
      delete :unvote, params: { id: model }, format: :json
      expect(model.votes.summarize).to eq 0
    end
  end
end
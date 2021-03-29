require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_many(:answers) }
    it { should have_many(:questions) }
  end

  describe 'methods' do

    describe 'author' do

      context 'of cuestion' do
        let!(:question) { create(:question) }
        let!(:user) { create(:user) }

        it 'user creating question is author' do
          expect(question.user.author?(question)).to be true
        end

        it 'random user is not author' do
          expect(user.author?(question)).to be false
        end
      end

      context 'of answer' do
        let!(:answer) { create(:answer) }
        let!(:user) { create(:user) }
        
        it 'user creating answer is author' do
          expect(answer.user.author?(answer)).to be true
        end

        it 'random user is not author' do
          expect(user.author?(answer)).to be false
        end
      end
    end

    describe 'upvoted?' do

      context 'question' do
        let(:question) { create(:question) }
        let(:user) { create(:user) }
        let!(:vote) { create(:vote, parent: question) }

        it 'is upvoted by user' do
          expect(vote.user.upvoted?(question)).to be true
        end
        it 'is not upvoted by random user' do
          expect(user.upvoted?(question)).to be false
        end
      end

      context 'answer' do
        let(:answer) { create(:answer) }
        let(:user) { create(:user) }
        let!(:vote) { create(:vote, parent: answer) }

        it 'is upvoted by user' do
          expect(vote.user.upvoted?(answer)).to be true
        end
        it 'is not upvoted by random user' do
          expect(user.upvoted?(answer)).to be false
        end
      end
    end
  end
end

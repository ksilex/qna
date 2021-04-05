require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_many(:answers) }
    it { should have_many(:questions) }
  end

  describe 'methods' do

    describe '.from_omniauth' do
      let(:no_email_auth) { OmniAuth.config.add_mock(:vkontakte, {:uid => '12345', :provider => 'vkontakte'}) }
      let(:with_email) { OmniAuth.config.add_mock(:vkontakte, {:uid => '12345', :provider => 'vkontakte', :info => {:email => 'test@mail.com'}}) }
      let(:signed_up_user) { create(:user, uid: no_email_auth.uid, provider: no_email_auth.provider)}

      it 'returns user if email provided' do
        expect(User.from_omniauth(with_email)).to be_instance_of User
      end

      it 'returns has no email if no email provided' do
        expect(User.from_omniauth(no_email_auth)).to eq 'has no email'
      end

      it 'returns user if user already signed up' do
        signed_up_user
        expect(User.from_omniauth(no_email_auth)).to eq signed_up_user
      end
    end

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

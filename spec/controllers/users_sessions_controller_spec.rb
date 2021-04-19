require 'rails_helper'

RSpec.describe Users::SessionsController, type: :controller do
  let!(:question) { create(:question) }
  let(:user) { create(:user) }

  describe 'POST #subscribe_to_question' do
    before { login(user) }
    it 'saves a new subscribtion in database' do
      expect { post :subscribe_to_question, params: { question_id: question.id } }.to change(user.subscriptions, :count).by(1)
    end
  end

  describe 'DELETE #unsubscribe_from_question' do
    before do
      create(:subscription, user: user, question: question)
      login(user)
    end
    it 'deletes subscription from database' do
      expect { delete :unsubscribe_from_question, params: { question_id: question.id } }.to change(user.subscriptions, :count).by(-1)
    end
  end
end

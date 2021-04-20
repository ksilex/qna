require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let!(:question) { create(:question) }
  let(:user) { create(:user) }

  describe 'POST #subscribe_to_question' do
    before { login(user) }
    it 'saves a new subscription in database' do
      expect { post :create, params: { question_id: question.id } }.to change(user.subscriptions, :count).by(1)
    end
  end

  describe 'DELETE #unsubscribe_from_question' do
    let!(:subscription) { create(:subscription, user: user, question: question) }
    before { login(user) }
    it 'deletes subscription from database' do
      expect { delete :destroy, params: { id: subscription.id } }.to change(user.subscriptions, :count).by(-1)
    end
  end

end

require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let!(:answer) { create(:answer) }
  describe 'GET #new' do
    before { get :new, params: { question_id: answer.question } }

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect { post :create, params: { answer: attributes_for(:answer),
                                         question_id: answer.question }
        }.to change(Answer, :count).by(1)
      end

      it 'redirects to associated question' do
        post :create, params: { answer: attributes_for(:answer), question_id: answer.question }
        expect(response).to redirect_to answer.question
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { answer: attributes_for(:answer, :invalid_answer),
                                         question_id: answer.question }
        }.to_not change(Answer, :count)
      end

      it 're-renders new view' do
        post :create, params: { answer: attributes_for(:answer, :invalid_answer), question_id: answer.question }
        expect(response).to render_template :new
      end
    end
  end
end

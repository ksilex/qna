require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let!(:answer) { create(:answer) }
  let(:user) { create(:user) }

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect { post :create, params: { answer: attributes_for(:answer),
                                         question_id: answer.question }
        }.to change(answer.question.answers, :count).by(1)
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
        }.to_not change(answer.question.answers, :count)
      end

      it 're-renders new view' do
        post :create, params: { answer: attributes_for(:answer, :invalid_answer), question_id: answer.question }
        expect(response).to render_template 'questions/show'
      end
    end
  end

  describe 'GET #edit' do
    before { login(user) }
    before { get :edit, params: { id: answer } }

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'PATCH #update' do
    before { login(user) }

    context 'with valid attributes' do
      it 'changes answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'redirects to associated question' do
        patch :update, params: { id: answer, answer: attributes_for(:answer) }
        expect(response).to redirect_to answer.question
      end
    end

    context 'with invalid attributes' do
      before { patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid_answer) } }

      it 'does not change answer' do
        answer.reload
        expect(answer.body).to eq answer.body
      end

      it 're-renders edit view' do
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'with user being author' do
      before { login(answer.user) }

      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer } }.to change(answer.question.answers, :count).by(-1)
      end
      
      it 'redirects to associated question' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to answer.question
      end
    end

    context 'with user not being author' do
      before { login(user) }

      it 'does not deletes the answer' do
        expect { delete :destroy, params: { id: answer } }.to_not change(answer.question.answers, :count)
      end
    end
  end
end

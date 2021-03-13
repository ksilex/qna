require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let!(:answer) { create(:answer) }
  let(:user) { create(:user) }

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect { post :create, params: { answer: attributes_for(:answer),
                                         question_id: answer.question }, 
                               format: :js
        }.to change(answer.question.answers, :count).by(1)
      end

      it 'renders create' do
        post :create, params: { answer: attributes_for(:answer), question_id: answer.question }, format: :js
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { answer: attributes_for(:answer, :invalid_answer),
                                         question_id: answer.question }, format: :js
        }.to_not change(answer.question.answers, :count)
      end

      it 'renders create' do
        post :create, params: { answer: attributes_for(:answer, :invalid_answer), question_id: answer.question }, format: :js
        expect(response).to render_template :create
      end
    end
  end

  describe 'GET #edit' do
    context 'with user being author' do
      before { login(answer.user) }
      before { get :edit, params: { id: answer } }

      it 'renders edit view' do
        expect(response).to render_template :edit
      end
    end
    context 'with user not being author' do
      before { login(user) }
      before { get :edit, params: { id: answer } }

      it 'does not renders edit view' do
        expect(response).to_not render_template :edit
      end
    end
  end

  describe 'PATCH #update' do
    context 'with user being author' do
      before { login(answer.user) }
      context 'with valid attributes' do
        it 'changes answer attributes' do
          patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
          answer.reload
          expect(answer.body).to eq 'new body'
        end

        it 'renders update view' do
          patch :update, params: { id: answer, answer: attributes_for(:answer) }, format: :js
          expect(response).to render_template :update
        end
      end

      context 'with invalid attributes' do
        before { patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid_answer) }, format: :js }

        it 'does not change answer' do
          answer.reload
          expect(answer.body).to eq answer.body
        end

        it 'renders update view' do
          expect(response).to render_template :update
        end
      end
    end
    context 'with user not being author' do
      before { login(user) }
      it 'does not changes answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        answer.reload
        expect(answer.body).to eq answer.body
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

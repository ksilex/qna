require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }
  let(:user) { create(:user) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3) }
    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'renders show view' do
      expect(response).to render_template :show
    end

    # it 'assigns new link for answer' do
    #   expect(assigns(:answer).links.first).to be_a_new(Link)
    # end
  end

  describe 'GET #new' do
    before { login(user) }
    before { get :new }

    it 'renders new view' do
      expect(response).to render_template :new
    end

    # it 'assigns a new link for question' do
    #   expect(assigns(:question).links.first).to be_a_new(Link)
    # end
  end

  describe 'GET #edit' do
    context 'with user being author' do
      before { login(question.user) }
      before { get :edit, params: { id: question }, xhr: true }

      it 'renders edit view' do
        expect(response).to render_template :edit
      end
    end
    context 'with user not being author' do
      before { login(user) }
      before { get :edit, params: { id: question }, xhr: true }

      it 'does not renders edit view' do
        expect(response).to_not render_template :edit
      end
    end
  end

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new question in the database' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, params: { question: attributes_for(:question, :invalid_question) } }
        .to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, params: { question: attributes_for(:question, :invalid_question) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    context 'with user being author' do
      before { login(question.user) }
      context 'with valid attributes' do
        it 'changes question attributes' do
          patch :update, params: { id: question, question: { title: 'new title', body: 'new body' } }, format: :js
          question.reload
          expect(question.title).to eq 'new title'
          expect(question.body).to eq 'new body'
        end

        it 'renders update view' do
          patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
          expect(response).to render_template :update
        end
      end

      context 'with invalid attributes' do
        before { patch :update, params: { id: question, question: attributes_for(:question, :invalid_question) }, format: :js }

        it 'does not change question' do
          question.reload
          expect(question.body).to eq question.body
        end

        it 'renders update view' do
          expect(response).to render_template :update
        end
      end
    end
    context 'with user not being author' do
      before { login(user) }
      it 'does not changes question attributes' do
        patch :update, params: { id: question, question: { body: 'new body' } }, format: :js
        question.reload
        expect(question.body).to eq question.body
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'with user being author' do
      before { login(question.user) }

      it 'deletes the question' do
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
      end

      it 'redirects to index' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end

    context 'with user not being author' do
      let!(:question) { create(:question) }
      before { login(user) }

      it 'does not deletes the question' do
        expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
      end
    end
  end
end

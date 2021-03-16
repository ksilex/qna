require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:user) { create(:user) }

  describe 'DELETE #destroy' do
    context 'file attached to question' do
      let!(:question) { create(:question, :with_file) }
      context 'with user being author' do
        before { login(question.user) }

        it 'deletes the file' do
          expect { delete :destroy, params: { id: question.files.first.id }, format: :js }.to change(question.files, :count).by(-1)
        end

        it 'renders destroy view' do
          delete :destroy, params: { id: question.files.first.id }, format: :js
          expect(response).to render_template :destroy
        end
      end

      context 'with user not being author' do
        before { login(user) }

        it 'does not deletes the file' do
          expect { delete :destroy, params: { id: question.files.first.id }, format: :js }.to_not change(question.files, :count)
        end
      end
    end

    context 'file attached to answer' do
      let!(:answer) { create(:answer, :with_file) }
      context 'with user being author' do
        before { login(answer.user) }

        it 'deletes the file' do
          expect { delete :destroy, params: { id: answer.files.first.id }, format: :js }.to change(answer.files, :count).by(-1)
        end

        it 'renders destroy view' do
          delete :destroy, params: { id: answer.files.first.id }, format: :js
          expect(response).to render_template :destroy
        end
      end

      context 'with user not being author' do
        before { login(user) }

        it 'does not deletes the file' do
          expect { delete :destroy, params: { id: answer.files.first.id }, format: :js }.to_not change(answer.files, :count)
        end
      end
    end
  end
end

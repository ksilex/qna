require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  let(:user) { create(:user) }

  describe 'DELETE #destroy' do
    context 'link attached to question' do
      let!(:question) { create(:question, :with_link) }
      context 'with user being author' do
        before { login(question.user) }

        it 'deletes the link' do
          expect { delete :destroy, params: { id: question.links.first.id }, format: :js }.to change(question.links, :count).by(-1)
        end

        it 'renders destroy view' do
          delete :destroy, params: { id: question.links.first.id }, format: :js
          expect(response).to render_template :destroy
        end
      end

      context 'with user not being author' do
        before { login(user) }

        it 'does not deletes the file' do
          expect { delete :destroy, params: { id: question.links.first.id }, format: :js }.to_not change(question.links, :count)
        end
      end
    end

    context 'link attached to answer' do
      let!(:answer) { create(:answer, :with_link) }
      context 'with user being author' do
        before { login(answer.user) }

        it 'deletes the link' do
          expect { delete :destroy, params: { id: answer.links.first.id }, format: :js }.to change(answer.links, :count).by(-1)
        end

        it 'renders destroy view' do
          delete :destroy, params: { id: answer.links.first.id }, format: :js
          expect(response).to render_template :destroy
        end
      end

      context 'with user not being author' do
        before { login(user) }

        it 'does not deletes the link' do
          expect { delete :destroy, params: { id: answer.links.first.id }, format: :js }.to_not change(answer.links, :count)
        end
      end
    end
  end
end

require 'sphinx_helper'

RSpec.describe SearchController, type: :controller do
  describe 'GET #index' do
    before { get :index, params: { query: 'test' } }
    it 'renders index view' do
      expect(response).to render_template :index
    end
  end
end

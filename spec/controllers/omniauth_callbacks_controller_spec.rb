require 'rails_helper'

RSpec.describe Users::OmniauthCallbacksController, type: :controller do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe 'Github' do
    let(:oauth_data) { {'provider' => 'github', 'uid' => 123 } }

    it 'finds user from oauth data' do
      allow(request.env).to receive(:[]).and_call_original
      allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
      expect(User).to receive(:from_omniauth).with(oauth_data)
      get :github
    end

    context 'user exists' do
      let!(:user) { create(:user) }

      before do
        allow(User).to receive(:from_omniauth).and_return(user)
        get :github
      end

      it 'login user' do
        expect(subject.current_user).to eq user
      end


      it 'redirects to root path' do
        expect(response).to redirect_to root_path
      end
    end

    context 'user does not exist' do
      before do
        allow(User).to receive(:from_omniauth)
        get :github
      end

      it 'redirects to root path' do
        expect(response).to redirect_to new_user_registration_path
      end


      it 'does not login user' do
        expect(subject.current_user).to_not be
      end
    end
  end

  describe 'Vkontakte' do
    let(:oauth_data) { {'provider' => 'vkontakte', 'uid' => 123 } }

    it 'finds user from oauth data' do
      allow(request.env).to receive(:[]).and_call_original
      allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
      expect(User).to receive(:from_omniauth).with(oauth_data)
      get :vkontakte
    end

    context 'user exists' do
      let!(:user) { create(:user) }

      before do
        allow(User).to receive(:from_omniauth).and_return(user)
        get :vkontakte
      end

      it 'login user' do
        expect(subject.current_user).to eq user
      end


      it 'redirects to root path' do
        expect(response).to redirect_to root_path
      end
    end

    context 'user does not exist' do
      before do
        allow(User).to receive(:from_omniauth)
        get :vkontakte
      end

      it 'redirects to root path' do
        expect(response).to redirect_to new_user_registration_path
      end


      it 'does not login user' do
        expect(subject.current_user).to_not be
      end
    end
  end

  describe 'POST verified oauth' do
    it 'saves user if email provided' do
      controller.session[:uid] = '12345'
      controller.session[:provider] = 'vkontakte'
      expect { post :verified_oauth, params: { email: 'test@mail.com' }
              }.to change(User, :count).by(1)
    end

    it 'does not saves user if no email provided' do
      controller.session[:uid] = '12345'
      controller.session[:provider] = 'vkontakte'
      expect { post :verified_oauth
              }.to_not change(User, :count)
    end
  end

  describe 'GET set_email' do
    it 'renders set email template' do
      controller.session[:uid] = '12345'
      controller.session[:provider] = 'vkontakte'
      get :set_email
      expect(response).to render_template :set_email
    end

    it 'can not be accessed directly' do
      get :set_email
      expect(response).to_not render_template :set_email
    end
  end
end

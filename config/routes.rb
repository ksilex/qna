Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, controllers: { sessions: 'users/sessions', confirmations: 'confirmations',
                                    omniauth_callbacks: 'users/omniauth_callbacks' }
  devise_scope :user do
    get "profile", to: "users/sessions#profile"
    get "set_email", to: "users/omniauth_callbacks#set_email"
    post "verified_oauth", to: "users/omniauth_callbacks#verified_oauth"
  end
  root to: "questions#index"
  concern :votes do
    member do
      post :upvote
      post :downvote
      delete :unvote
    end
  end
  concern :comments do
    resources :comments, only: [:create, :new]
  end
  resources :questions, concerns: [:votes, :comments] do
    resources :answers, concerns: [:votes, :comments], shallow: true, except: %i[index show] do
      member do
        patch :best
      end
    end
  end
  resources :attachments, only: :destroy
  resources :links, only: :destroy

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [] do
        get :me, on: :collection
      end
      resources :questions, only: [:index, :show, :create] do
        resources :answers, shallow: true
      end
    end
  end
end

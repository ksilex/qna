Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'users/sessions' }
  devise_scope :user do
    get "profile", to: "users/sessions#profile"
  end
  root to: "questions#index"
  concern :votes do
    member do
      post :upvote
      post :downvote
    end
  end
  resources :questions, concerns: :votes do
    resources :answers, concerns: :votes, shallow: true, except: %i[index show] do
      member do
        patch :best
      end
    end
  end
  resources :attachments, only: :destroy
  resources :links, only: :destroy
end

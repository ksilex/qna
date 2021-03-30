Rails.application.routes.draw do
  get 'comments/create'
  devise_for :users, controllers: { sessions: 'users/sessions' }
  devise_scope :user do
    get "profile", to: "users/sessions#profile"
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
    resources :comments, only: :create
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
end

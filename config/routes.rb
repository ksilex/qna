Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'users/sessions' }
  devise_scope :user do
    get "profile", to: "users/sessions#profile"
  end
  root to: "questions#index"
  resources :questions do
    resources :answers, shallow: true, except: %i[index show] do
      member do
        patch :best
      end
    end
  end
  resources :attachments, only: :destroy
  resources :links, only: :destroy
end

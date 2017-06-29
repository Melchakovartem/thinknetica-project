Rails.application.routes.draw do
  devise_for :users
  resources :questions do
    resources :answers do
      patch :select, on: :member
    end
  end

  resources :attachments, only: [:destroy]

  resources :votes, only: [:create, :destroy]
  resources :comments, only: [:create]

  root to: "questions#index"

  mount ActionCable.server => "/cable"
end

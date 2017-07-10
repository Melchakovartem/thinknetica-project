Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: "omniauth_callbacks" }

  devise_scope :user do
    post '/confirm_email' => 'omniauth_callbacks#confirm_email'
  end

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

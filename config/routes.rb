require "sidekiq/web"

Rails.application.routes.draw do
  mount Sidekiq::Web => "/sidekiq"

  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: "omniauth_callbacks" }

  devise_scope :user do
    post '/confirm_email' => 'omniauth_callbacks#confirm_email'
  end

  resources :questions do
    resources :answers do
      patch :select, on: :member
    end

    resources :subscriptions, only: [:create, :destroy]
  end

  resources :attachments, only: [:destroy]

  resources :votes, only: [:create, :destroy]
  resources :comments, only: [:create]

  root to: "questions#index"

  mount ActionCable.server => "/cable"

  namespace :api do
    namespace :v1 do
      resources :profiles, only: :index do
        get :me, on: :collection
      end
      resources :questions do
        resources :answers, shallow: true
      end
    end
  end
end

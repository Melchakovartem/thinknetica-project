Rails.application.routes.draw do
  devise_for :users
  resources :questions do
    resources :answers do
      patch :select, on: :member
    end
  end

  resources :attachments, only: [:destroy]

  resources :votes, only: [:create] do
    delete :destroy, on: :collection
  end

  root to: "questions#index"
end

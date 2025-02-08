Rails.application.routes.draw do
  resources :game_responses
  resources :questions do
    member do
      get :review
      patch :update_status
    end
  end
  resources :categories_courses
  resources :levels
  resources :categories
  resources :courses
  resources :roles
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :game_sessions, only: [:index, :show, :new, :create] do
    collection do
      get :play
      post :answer
      get :result
      get :history
    end
  end

  # config/routes.rb
  resources :admin, only: [:index] do
    collection do
      post 'upload_questions', to: 'admin#upload_questions'
    end
  end

  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  authenticated :user do
    root to: 'game_sessions#index', as: :authenticated_root
  end

  devise_scope :user do
    unauthenticated do
      root to: 'devise/sessions#new', as: :unauthenticated_root
    end
  end

  resources :users, only: [:index, :edit, :update, :destroy]
  resources :users do
    member do
      get :edit_password
      patch :update_password
    end
  end

  resources :kahoot_games, only: [:new, :create, :show, :destroy] do
    member do
      post :start
    end
  end
  
  match "*path", to: "application#handle_not_found", via: :all
  
end

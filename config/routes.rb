Rails.application.routes.draw do
  resources :game_responses
  resources :answers
  resources :questions
  resources :categories_courses
  resources :levels
  resources :categories
  resources :courses
  resources :roles
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :game_sessions, only: [:index, :new, :create] do
    collection do
      get :play
      post :answer
      get :result
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
    root to: 'courses#index', as: :authenticated_root 
  end

  devise_scope :user do
    unauthenticated do
      root to: 'devise/sessions#new', as: :unauthenticated_root
    end
  end

end

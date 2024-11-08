Rails.application.routes.draw do
  resources :answers
  resources :questions
  resources :categories_courses
  resources :levels
  resources :categories
  resources :courses
  resources :roles
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html


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

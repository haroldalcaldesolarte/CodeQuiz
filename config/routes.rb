Rails.application.routes.draw do
  resources :questions
  resources :categories_courses
  resources :levels
  resources :categories
  resources :courses
  resources :roles
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  
  #I'll change it so that it points to the games index
  root 'courses#index'

  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

end

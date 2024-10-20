Rails.application.routes.draw do
  #I'll change it so that it points to the games index
  root 'courses#index'

  resources :courses
  resources :roles
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

end

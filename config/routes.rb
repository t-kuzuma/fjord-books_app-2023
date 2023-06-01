Rails.application.routes.draw do
  devise_for :users
  resources :books
  resources :users, only: [:index, :show, :edit, :update]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "books#index"
end

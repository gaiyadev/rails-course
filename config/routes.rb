Rails.application.routes.draw do
  resources :users, only: [:show, :destroy, :create]
  resources :courses
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  put '/users/change_password', to: 'users#change_password'
  post '/users/login', to: 'users#login'

  # Defines the root path route ("/")
  # root "articles#index"
  root 'welcome#index'
end

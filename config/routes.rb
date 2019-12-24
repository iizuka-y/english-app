Rails.application.routes.draw do
  root 'home#index'

  get 'sessions/new'
  get  '/signup',  to: 'users#new'
  post  '/signup',  to: 'users#create'

  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :users
  resources :posts, only: [:new, :create, :edit, :update, :destroy]

end

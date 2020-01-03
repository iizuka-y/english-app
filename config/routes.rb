Rails.application.routes.draw do
  root 'home#index'
  get  '/notification',  to: 'home#notification'
  post '/notification',  to: 'home#create'

  get 'sessions/new'
  get  '/signup',  to: 'users#new'
  post  '/signup',  to: 'users#create'

  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'

  resources :users do
    resource :mutes, only: [:create, :destroy]
    member do
      get :evaluated
    end
  end

  resources :posts, only: [:show, :new, :create, :edit, :update, :destroy] do
    resource :evaluations, only: [:create, :destroy]
    resource :comments, only: [:create, :destroy]
  end


end

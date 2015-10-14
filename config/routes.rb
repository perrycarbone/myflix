Myflix::Application.routes.draw do
  root to: 'users#front'

  get 'ui(/:action)', controller: 'ui'
  get '/home', to: 'videos#index'
  get '/register', to: 'users#new'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  get '/my_queue', to: 'queue_items#index'

  resources :videos, only: [:index, :show] do
    collection do
      get '/search', to: 'videos#search'
    end
    resources :reviews, only: [:create]
  end

  resources :categories, only: [:show]
  resources :users, only: [:create, :show, :edit, :update]
  get 'people', to: 'relationships#index'
  resources :relationships, only: [:create, :destroy]

  resources :queue_items, only: [:create, :destroy]
  post 'update_queue', to: 'queue_items#update_queue'

  get 'forgot_password', to: 'forgot_passwords#new'
  resources :forgot_passwords, only: [:create]
  get 'forgot_password_confirmation', to: 'forgot_passwords#confirm'

  resources :password_resets, only: [:show]
  get 'expired_token', to: 'password_resets#expired_token'
end

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
  resources :queue_items, only: [:create]
end

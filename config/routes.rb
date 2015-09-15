Myflix::Application.routes.draw do
  root to: 'users#front'

  get 'ui(/:action)', controller: 'ui'
  get '/home', to: 'videos#index'
  get '/register', to: 'users#new'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  resources :videos, only: [:index, :show] do
    collection do
      get '/search', to: 'videos#search'
    end
  end

  resources :categories, only: [:show]
  resources :users, only: [:create, :show, :edit, :update]
end

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
    namespace :api do 
      namespace :v1 do
        resources :users, only: [:show, :index]
        # resources :users, only: [:show]
        resources :sessions, only: [:destroy]
        # resources :sessions, only: [:create, :destroy]
        # ///////
        post '/signup', to: 'sessions#create'
        post '/login', to: 'sessions#login'
        get '/logged_in', to: 'sessions#is_logged_in?'

      end
    end
end

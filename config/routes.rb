Rails.application.routes.draw do
  
  root "movies#index"

  get "movies/filter/:filter" => "movies#index", as: :filtered_movies

  resources :movies do
    resources :reviews
    resources :favourites, only: [:create, :destroy]
  end

  resources :users

  get "signup" => "users#new"

  resource :session, only: [:new, :create, :destroy]

  get "signin" => "sessions#new"

  resources :genres
  
end

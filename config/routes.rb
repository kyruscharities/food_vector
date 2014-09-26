require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq' unless Rails.env.production?

  resources :geographic_data_points

  resources :food_sources

  resources :analyzed_geo_blocks

  resources :analyses do
    member do
      post :analyze
      post :locate_food_sources
    end
  end

  scope '/' do
    get 'home' => 'static_pages#home'
  end

  root to: 'static_pages#home'

  devise_for :users
  resources :users
end

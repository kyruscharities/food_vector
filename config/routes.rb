require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq' unless Rails.env.production?

  resources :geographic_data_points

  resources :food_sources

  resources :analyzed_geo_blocks

  resources :analyses, except: [:edit] do
    member do
      post :analyze
    end
  end

  root to: 'analyses#index'

  devise_for :users
  resources :users
end

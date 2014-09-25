Rails.application.routes.draw do
  resources :geographic_data_points

  resources :food_sources

  resources :analyzed_geo_blocks

  resources :analyses

  root to: 'analyses#index'

  devise_for :users
  resources :users
end

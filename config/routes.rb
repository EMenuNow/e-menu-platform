Rails.application.routes.draw do


  resources :tables
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  namespace :manager do
    get 'home/index'
    get 'home/dashboard'
    get 'home/menu'
    resources :cuisines
    resources :restaurants do 
      resources :menus
      resources :restaurant_tables
    end
    devise_for :restaurant_users, path: 'manager', controllers: {
      sessions: 'manager/restaurant_users/sessions',
      registrations: 'manager/restaurant_users/registrations'
    }
  end

  get 'home_mobile/index'
  get 'home/index'
  post 'home/register_table'
  get 'home/register_table/:code' => 'home#register_table', as: :register_table
  post 'home/start_table/:table_id' => "home#start_table", via: [:get, :post], as: :start_table
  get 'home/table'


  root 'home#index'

end

# frozen_string_literal: true

Rails.application.routes.draw do



  resources :receipts do 
    post 'is_ready'
    collection do 
      get 'view_receipt/:uuid', to: 'receipts#view_receipt', as: :view_receipt
    end
  end
  namespace :restaurant do
    get 'list' => "home#index"
    get 'booking/:slug' => "booking#index", as: :booking
    get 'menu/:slug' => "menu#index", as: :menu

  end



  resources :tables do
    post 'add_item/:menu_id' => 'tables#add_item', as: :add_item
    get 'pay'
    post 'stripe'
    get 'finish'
    get 'manager_finish'
    # get 'sectioned_menus'
    get 'sectioned_menus/:menu_id' => 'tables#show', as: 'sectioned_menus_choice'

  end
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  namespace :api do
    namespace :v1 do
      get 'menu/:id' => 'menu#index'
      get 'menu_item/:id', to: 'menu#menu_item'
      get 'menu_optionals', to: 'menu#menu_optionals'
      get 'menu_optionals/:items', to: 'menu#menu_optionals'
    end
  end

  

  namespace :manager do
    get 'home/index'
    get 'home/dashboard'
    get 'home/menu'

    get 'live_tables/:restaurant_id' => 'live#tables', as: :live_tables
    get 'live_items/:restaurant_id' => 'live#items', as: :live_items
    get 'live_orders/:restaurant_id' => 'live#orders', as: :live_orders
    get 'receipts/:restaurant_id' => 'live#receipts', as: :receipts
    get 'send_receipt/:receipt_id' => 'live#send_receipt', as: :send_receipts
    get 'service/:restaurant_id/item/:table_item_id' => 'live#service', as: :live_service
    get 'ready/:restaurant_id/item/:table_item_id' => 'live#ready', as: :live_ready

    resources :features
    resources :templates  
    resources :settings
    resources :packages do
      post 'add_feature/:feature_id', action: :add_feature, as: :add_feature
      post 'remove_feature/:feature_id', action: :remove_feature, as: :remove_feature
    end

    resources :cuisines
    resources :restaurants do

      resources :delivery_postcodes
      
      post 'add_feature/:feature_id', action: :add_feature, as: :add_feature
      post 'remove_feature/:feature_id', action: :remove_feature, as: :remove_feature
      get 'active', action: :active
      post 'toggle_active', action: :toggle_active
      post 'add_template', action: :add_template


      resources :menus do
        post :clone
      end
      resources :restaurant_tables do
        collection do
          get :qr
        end
      end
      resources :custom_lists do 
        resources :custom_list_items
        post :up
        post :down
      end
    end
    devise_for :restaurant_users, path: 'manager', controllers: {
      sessions: 'manager/restaurant_users/sessions',
      registrations: 'manager/restaurant_users/registrations'
    }
  end


  get 'order/remove_from_basket/:path/:uuid', to: 'order#remove_from_basket', as: :remove_from_basket
  get 'order/receipt/:path/:uuid', to: 'order#receipt', as: :order_receipt
  get 'order/checkout/:path', to: 'order#checkout', as: :checkout
  get 'order/checkoutx/:path', to: 'order#checkoutx', as: :checkoutx
  post 'order/stripe/:path', to: 'order#stripe', as: :stripe
  post 'order/stripex/:path', to: 'order#stripex', as: :stripex
  get 'order/basket/:path', to: 'order#basket', as: :basket
  get 'order/add_to_basket/:path', to: 'order#add_to_basket', as: :add_to_basket_base
  get 'order/add_to_basket/:path/:main_item', to: 'order#add_to_basket', as: :add_to_basket
  get 'order/add_to_basket/:path/:main_item/:items', to: 'order#add_to_basket', as: :add_to_basket_items
  get 'order/:path', to: 'order#index', as: :restaurant_path



  get 'home_mobile/index'
  get 'home/index'
  post 'home/register_table'
  get 'home/register_table/:code' => 'home#register_table', as: :register_table
  post 'home/start_table/:table_id' => 'home#start_table', via: %i[get post], as: :start_table
  get 'home/table'
  post 'home/set_locale/:language_id' => 'home#set_locale', as: :home_set_locale


   get '/:name', to: 'restaurant/menu#name'


  root 'home#index'
end

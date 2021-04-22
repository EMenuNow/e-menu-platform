Rails.application.routes.draw do
  devise_for :patrons, controllers: {
    sessions: 'patrons/sessions',
    registrations: 'patrons/registrations'
  }
  resources :raspberry_pi_statuses
  resources :raspberry_pi_updates do
    collection do
      get :latest
      get :version
      get :files
    end
  end

  resources :stripe_webhooks, :path => "stripe-webhooks", :only => [] do
    collection do
      post :webhook, path: ""
    end
  end

  # namespace :manager do
  #   resources :printers
  # end
  resources :item_screen_types 
  
  resources :orders, :only => [:index, :show]
  resources :restaurants, :only => [:show], :path => "" do
    member do
      get :order
      get :welcome
      resources :checkouts, only: [:index, :create] do
        collection do
          get :pay
          post :pay
          post :stripe
          resources :receipt, only: [], param: :uuid do
            member do
              get :show, to: "checkouts#receipt"
            end
          end
        end
      end
    end
  end

  resources :patrons, :module => :patrons, :only => [:index, :show] do
    collection do
      get :settings, :to => "patrons#show"
      resources :orders, :only => [:index]
      resources :patron_allergens, :only => [:update]
      resources :patron_marketing_preferences, :only => [:update]
    end
  end

  resources :receipts do 
    post :queue_order
    post :send_to_kitchen
    post :preparing
    post 'is_ready'
    post :complete
    post 'is_item_ready/:screen_item_id', to: 'receipts#is_item_ready', as: :screen_item_ready
    post 'is_item_process/:screen_item_id', to: 'receipts#is_item_process', as: :screen_item_process
    post 'is_items_ready/:receipt_id/item_screen_type_key/:item_screen_type_key', to: 'receipts#is_items_ready', as: :screen_items_ready
    post 'is_items_preparing/:receipt_id/item_screen_type_key/:item_screen_type_key', to: 'receipts#is_items_preparing', as: :screen_items_preparing
    post 'item_creation_broadcast'
    post 'creation_broadcast'
    collection do 
      get 'view_receipt/:uuid', to: 'receipts#view_receipt', as: :view_receipt
    end
  end
  namespace :restaurant do
    get 'list' => "home#index"
    get 'booking/:slug' => "booking#index", as: :booking
    get 'menu/:slug' => "menu#index", as: :menu

    resources :menu, :only => [:index]

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
      resources :receipts, only: [:update]
    end
  end
  namespace :manager do
    resources :restaurants, :param => :restaurant_id do
      member do
        resources :discount_codes
        resources :orders, :only => [] do
          member do
            resources :refunds, only: [:create]
          end
        end
      end
      collection do
        resources :administrations, :only => [:index] do
          member do
            get :login_as
          end
        end
        resources :reports, :only => [:index]
      end
    end
    resources :home do
      collection do
        get :dashboard
        get :menu
      end
    end

    get 'live_tables/:restaurant_id' => 'live#tables', as: :live_tables
    get 'live_items/:restaurant_id' => 'live#items', as: :live_items
    get 'live_orders/:restaurant_id/kitchen' => 'live#kitchen', as: :live_orders_kitchen
    get 'live_orders/:restaurant_id' => 'live#orders', as: :live_orders
    get 'live_orders/broadcast/:restaurant_id' => 'live#orders_broadcast', as: :live_orders_broadcast
    get 'live_food/:restaurant_id' => 'live#food', as: :live_food
    get 'live_food/broadcast/:restaurant_id' => 'live#orders_broadcast', as: :live_food_broadcast
    get 'live_drinks/:restaurant_id' => 'live#drinks', as: :live_drinks
    get 'live_drinks/broadcast/:restaurant_id' => 'live#orders_broadcast', as: :live_drinks_broadcast
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

      post 'set_delay'
      post 'reporting/daily'
      get 'reporting/daily'
      get 'reporting/zreport_show/:daily_reporting_id', to: 'reporting#zreport_show', as: :zreport

      resources :opening_times
      resources :busy_times, except: [:update]
      resources :delivery_postcodes

      resources :themes

      resources :item_screens

      resources :pi_interfaces do 
        get :request_lsusb
        resources :printers 
      end
      post 'add_feature/:feature_id', action: :add_feature, as: :add_feature
      post 'remove_feature/:feature_id', action: :remove_feature, as: :remove_feature
      post 'toggle_feature/:feature_id', action: :toggle_feature, as: :toggle_feature
      get 'active', action: :active
      post 'toggle_active', action: :toggle_active
      post 'add_template', action: :add_template


      resources :menus do
        post :clone
        post 'toggle_active', action: :toggle_active
      end
      resources :restaurant_tables do
        collection do
          get :qr
        end
      end
      resources :custom_lists do 
        resources :custom_list_items do
          post 'toggle_active', action: :toggle_active
        end
        post :up
        post :down
      end
    end
    devise_for :restaurant_users, path: 'manager', controllers: {
      sessions: 'manager/restaurant_users/sessions',
      registrations: 'manager/restaurant_users/registrations',
      passwords: 'manager/restaurant_users/passwords'
    }
  end

  namespace :onboarding do
    resources :restaurants do
      get 'services'
      get 'connect'
      get 'complete'
      post 'toggle_feature/:feature_id', action: :toggle_feature, as: :toggle_feature
      post 'dashboard_login', action: :dashboard_login, as: :dashboard_login
    end
    
    get 'start', to: 'home#start'
    get 'continue', to: 'home#continue'
    patch 'agree', to: 'home#tos_agree'

    devise_for :restaurant_users, path: '/', controllers: {
      sessions: 'onboarding/restaurant_users/sessions',
      registrations: 'onboarding/restaurant_users/registrations',
      passwords: 'onboarding/restaurant_users/passwords'
    }
  end

#printing

get 'receipt/:receipt_id/print/:printer_id', to: 'manager/printers#print', as: :print_receipt
get 'receipt/:receipt_id/screen_item_uuid/:uuid/print/:printer_id', to: 'manager/printers#print_item', as: :print_item_receipt
get 'receipt/:receipt_id/key/:item_screen_type_key/print/:printer_id', to: 'manager/printers#print_items', as: :print_items_receipt


  # get 'order/remove_from_basket/:path/:uuid', to: 'order#remove_from_basket', as: :remove_from_basket
  # get 'order/receipt/:path/:uuid', to: 'order#receipt', as: :order_receipt
  # get 'order/checkout/:path', to: 'order#checkout', as: :checkout
  # post 'order/pay/:path', to: 'order#pay', as: :pay
  # get 'order/checkoutx/:path', to: 'order#checkoutx', as: :checkoutx
  # post 'order/stripe/:path', to: 'order#stripe', as: :stripe
  # get 'order/add_to_basket/:path', to: 'order#add_to_basket', as: :add_to_basket_base
  # get 'order/add_to_basket', to: 'baskets#index', as: :add_to_basket
  get 'baskets/:path/menu/:menu_id/section/:section_id', to: 'baskets#index', as: :order_menu_section
  # get 'order/:path/menu/:menu_id', to: 'restaurants#index', as: :order_menu
  get 'order/:path', to: 'order#index'

  resources :baskets, :only => [:update], param: :path

  get 'home_mobile/index'
  get 'home/index'
  post 'home/register_table'
  get 'home/register_table/:code' => 'home#register_table', as: :register_table
  post 'home/start_table/:table_id' => 'home#start_table', via: %i[get post], as: :start_table
  get 'home/table'
  post 'home/set_locale/:language_id' => 'home#set_locale', as: :home_set_locale

  get '/:name', to: 'restaurant/menu#index'

  root 'home#index'
end





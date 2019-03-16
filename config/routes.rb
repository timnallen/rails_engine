Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      namespace :merchants do
        get '/most_revenue', to: 'most_revenue#index'
        get '/most_items', to: 'most_items#index'
        get '/revenue', to: 'revenue#show'
        get '/find', to: 'search#show'
        get '/find_all', to: 'search#index'
        get '/random', to: 'random#show'
      end
      namespace :customers do
        get '/find', to: 'search#show'
        get '/find_all', to: 'search#index'
        get '/random', to: 'random#show'
      end
      namespace :invoice_items do
        get '/find', to: 'search#show'
        get '/find_all', to: 'search#index'
        get '/random', to: 'random#show'
      end
      resources :invoices, only: [:show] do
        resources :transactions, only: [:index]
        resources :invoice_items, only: [:index]
        resources :items, only: [:index]
        get '/customer', to: 'customer#show'
        get '/merchant', to: 'merchant#show'
      end
      resources :invoice_items, only: [:index, :show] do
        get '/invoice', to: 'invoices#show'
        get '/item', to: 'items#show'
      end
      resources :merchants, only: [:index, :show] do
        resources :items, only: [:index]
        resources :invoices, only: [:index]
        get '/revenue', to: 'revenue#show'
        get '/favorite_customer', to: 'favorite_customer#show'
        get '/customers_with_pending_invoices', to: 'pending_invoices#index'
      end
      namespace :items do
        get '/most_revenue', to: 'most_revenue#index'
        get '/most_items', to: 'most_items#index'
      end
      resources :items, only: [:show] do
        get '/best_day', to: 'best_day#show'
        get '/invoice_items', to: 'invoice_items#index'
        get '/merchant', to: 'merchant#show'
      end
      resources :customers, only: [:index, :show] do
        get '/favorite_merchant', to: 'favorite_merchant#show'
        get '/invoices', to: 'invoices#index'
        get '/transactions', to: 'transactions#index'
      end
      resources :transactions, only: [:show] do
        get '/invoice', to: 'invoices#show'
      end
    end
  end
end

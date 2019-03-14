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
        get 'random', to: 'random#show'
      end
      resources :merchants, only: [:index, :show] do
        get '/revenue', to: 'revenue#show'
        get '/favorite_customer', to: 'favorite_customer#show'
      end
    end
  end
end

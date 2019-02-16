require 'resque/server'

Rails.application.routes.draw do
  devise_for :users
  devise_scope :user do
    root to: 'visitors#home'
  end

  authenticated do
    resources :influencers, only: [:index, :new, :create, :edit, :update] do
      collection do
        post :import
        post :mark_active, controller: :influencers_status
        post :mark_inactive, controller: :influencers_status
        post :download_selected, controller: :influencers_download
        get :download_all, controller: :influencers_download
      end
    end

    resource :shopify_cache, only: [] do
      collection do
        put :refresh_all
      end
    end

    resources :influencer_orders, only: [:index] do
      collection do
        post :upload
        post :create
        post :delete
        post :create_once_a_month
      end
    end

    get '/influencers/search', to: 'influencers_search#search', as: 'influencers_search'
    get '/influencer_orders/search', to: 'influencer_orders_search#search', as: 'influencer_orders_search'

    #get "/404", to: "errors#not_found"
    #get "/422", to: "errors#unacceptable"
    #get "/500", to: "errors#internal_error"
    %w(404 422 500).each do |status_code|
      get status_code, to: "errors#show", status_code: status_code
    end



    mount Resque::Server, at: '/jobs'
  end
end

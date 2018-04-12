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
        post :download, controller: :influencers_download
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
        post :create_once_a_month
      end
    end

    get '/influencers/search', to: 'influencers#search', as: 'influencers_search'
    get '/influencer_orders/search', to: 'influencer_orders_search#search', as: 'influencer_orders_search'
  end

  mount Resque::Server, at: '/jobs'
end

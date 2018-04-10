require 'resque/server'

Rails.application.routes.draw do
  devise_for :users
  devise_scope :user do
    root to: 'visitors#home'
  end

  authenticated do
    resources :influencers, only: [:index, :new] do
      collection do
        post :import
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
      end
    end

    get '/influencers/search', to: 'influencers#search', as: 'influencers_search'
  end

  mount Resque::Server, at: '/jobs'
end

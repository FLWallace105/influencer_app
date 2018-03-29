require 'resque/server'

Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
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
  end

  mount Resque::Server, at: '/jobs'
end

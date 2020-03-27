# frozen_string_literal: true

require 'sidekiq/web'
Provider

Rails.application.routes.draw do
  root to: 'pages#index'

  devise_for :users,
    path: 'auth',
    path_names: {
      sign_in: 'login',
      sign_out: 'logout',
      registration: 'register',
      sign_up: 'sign_up'
    },
    controllers: {
      omniauth_callbacks: 'omniauth_callbacks'
    }

  authenticate :user, ->(user) { user.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  namespace :admin do
    resources :settings, only: [:index, :update]
  end

  resources :services, only: [:index, :new, :create, :update, :destroy] do
    collection do
      get :search
    end
  end

  resources :scrobblers do
    collection do
      resource :type_data, only: [:show], as: 'scrobbler_type_data', controller: 'scrobblers/type_data'
    end
  end

  resources :places, only: [:show, :new, :create, :update] do
    collection do
      get :search
    end
  end

  resources :locations, controller: 'location_scrobbles', only: [:index] do
    collection do
      resources :scrobbles, only: [:edit, :update], as: 'location_scrobbles', controller: 'location_scrobbles'

      resources :imports, except: [:index, :destroy], as: 'location_imports', controller: 'location_imports'
      resources :categories, only: [:index], as: 'location_categories', controller: 'location_categories'
    end
  end

  resources :place_matches, only: [:create, :update]

  namespace :aux do
    resources :countries, only: [:index]
  end

  match '/users/:user_id/webhooks/:scrobbler_id/:token' => 'webhooks#handle',
    as: 'webhooks',
    via: [:get, :post, :put, :patch, :delete]
end

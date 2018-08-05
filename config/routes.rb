# frozen_string_literal: true

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

  resources :services, only: [:index, :destroy]
  resources :locations, controller: 'location_scrobbles', only: [:index]
  namespace :locations do
    resource :import, except: [:index, :show, :destroy]
  end
end

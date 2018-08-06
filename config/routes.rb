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
  resources :locations, controller: 'location_scrobbles', only: [:index] do
    collection do
      resources :imports, except: [:index, :destroy], as: 'location_imports', controller: 'location_imports'
    end
  end
end

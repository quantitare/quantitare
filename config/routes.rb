# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'pages#welcome'

  devise_for :users,
    path: 'auth',
    path_names: {
      sign_in: 'login',
      sign_out: 'logout',
      registration: 'register',
      sign_up: 'sign_up'
    }
end

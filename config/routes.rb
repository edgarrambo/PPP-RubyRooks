# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'callbacks' }
  root 'games#index'
  resources :games, only: %i[index new create show]
  get "/games/:id", to: 'games#update_invited_user', as: :join
end

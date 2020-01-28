# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'callbacks' }
  root 'games#index'

  resources :pieces, only: %i[show update] do
    get :castle
    put :promotion
  end

  resources :games, only: %i[index new create show] do
    get :update_invited_user, :surrender, :draw
  end
end

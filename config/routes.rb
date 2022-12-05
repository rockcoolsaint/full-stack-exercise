# frozen_string_literal: true

Rails.application.routes.draw do
  resources :comments
  resources :applicants do
    resources :comments
  end
  resources :funds
  resources :payments, only: [:index]
  resources :projects

  root 'applicants#index'
end

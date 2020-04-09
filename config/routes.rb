# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  root 'expenses#index'

  devise_for :users, controllers: { sessions: 'sessions', registrations: 'registrations' }

  mount Sidekiq::Web => '/sidekiq'

  resources :expenses do
    collection do
      get :report
    end
  end

  resources :loans, except: [:edit]

  resources :expense_groups, only: [:create, :destroy, :index]

  resources :places, only: [:create, :destroy, :index]
end

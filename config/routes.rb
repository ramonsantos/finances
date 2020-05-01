# frozen_string_literal: true

Rails.application.routes.draw do
  root 'expenses#index'

  devise_for :users, controllers: { sessions: 'sessions', registrations: 'registrations' }

  resources :expenses do
    collection do
      get :report
      get :new_by_csv
      post :create_by_csv
    end
  end

  resources :loans, except: [:edit]

  resources :expense_categories, except: [:edit]

  resources :expense_groups, only: [:create, :destroy, :index]

  resources :places, only: [:create, :destroy, :index]
end

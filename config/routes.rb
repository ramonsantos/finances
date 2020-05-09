# frozen_string_literal: true

Rails.application.routes.draw do
  root 'expenses#index'

  devise_for :users, controllers: { sessions: 'sessions', registrations: 'registrations' }

  resources :expenses, except: [:edit] do
    collection do
      get :report
      get :new_from_csv
      post :create_from_csv
    end
  end

  resources :loans, except: [:edit]

  resources :expense_categories, except: [:edit]

  resources :expense_groups, only: [:create, :destroy, :index]

  resources :places, only: [:create, :destroy, :index]
end

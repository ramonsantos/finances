# frozen_string_literal: true

Rails.application.routes.draw do
  get 'up' => 'rails/health#show', as: :rails_health_check

  root 'expenses#index'

  resources :expenses, except: [:edit, :new, :show] do
    collection do
      get :report
    end
  end

  resources :expense_creators, only: [:create, :index, :show] do
    collection do
      get :download_csv_template
    end
  end

  resources :loans, except: [:edit]

  resources :expense_categories, except: [:edit, :new, :show]

  resources :payment_methods, except: [:edit, :new, :show]
end

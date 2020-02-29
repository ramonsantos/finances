# frozen_string_literal: true

Rails.application.routes.draw do
  root 'expenses#index'

  devise_for :users, controllers: { sessions: 'sessions' }

  resources :expenses, except: [:edit] do
    collection do
      get :report
    end
  end

  resources :expense_groups, except: [:edit, :update, :show]
  resources :places, except: [:edit, :update, :show]
end

# frozen_string_literal: true

Rails.application.routes.draw do
  root 'expenses#index'

  devise_for :users, controllers: { sessions: 'sessions' }

  resources :expenses, except: [:edit]
  resources :expense_groups, except: [:edit, :update, :show]
  resources :places, except: [:edit, :update, :show]
end

# frozen_string_literal: true

require 'rails_helper'

describe ExpenseCategoriesController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/expense_categories').to route_to('expense_categories#index')
    end

    it 'routes to #new' do
      expect(get: '/expense_categories/new').to route_to('expense_categories#new')
    end

    it 'routes to #show' do
      expect(get: '/expense_categories/1').to route_to('expense_categories#show', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/expense_categories').to route_to('expense_categories#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/expense_categories/1').to route_to('expense_categories#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/expense_categories/1').to route_to('expense_categories#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/expense_categories/1').to route_to('expense_categories#destroy', id: '1')
    end
  end
end

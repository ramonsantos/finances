# frozen_string_literal: true

require 'rails_helper'

describe ExpenseGroupsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/expense_groups').to route_to('expense_groups#index')
    end

    it 'routes to #create' do
      expect(post: '/expense_groups').to route_to('expense_groups#create')
    end

    it 'routes to #destroy' do
      expect(delete: '/expense_groups/1').to route_to('expense_groups#destroy', id: '1')
    end
  end
end

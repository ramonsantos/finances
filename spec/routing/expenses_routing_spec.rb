# frozen_string_literal: true

require 'rails_helper'

describe ExpensesController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/expenses').to route_to('expenses#index')
    end

    it 'routes to #report' do
      expect(get: '/expenses/report').to route_to('expenses#report')
    end

    it 'routes to #new' do
      expect(get: '/expenses/new').to route_to('expenses#new')
    end

    it 'routes to #new_by_csv' do
      expect(get: '/expenses/new_by_csv').to route_to('expenses#new_by_csv')
    end

    it 'routes to #show' do
      expect(get: '/expenses/1').to route_to('expenses#show', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/expenses').to route_to('expenses#create')
    end

    it 'routes to #create_by_csv' do
      expect(post: '/expenses/create_by_csv').to route_to('expenses#create_by_csv')
    end

    it 'routes to #update via PUT' do
      expect(put: '/expenses/1').to route_to('expenses#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/expenses/1').to route_to('expenses#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/expenses/1').to route_to('expenses#destroy', id: '1')
    end
  end
end

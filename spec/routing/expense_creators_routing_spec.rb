# frozen_string_literal: true

require 'rails_helper'

describe ExpenseCreatorsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/expense_creators').to route_to('expense_creators#index')
    end

    it 'routes to #create' do
      expect(post: '/expense_creators').to route_to('expense_creators#create')
    end
  end
end

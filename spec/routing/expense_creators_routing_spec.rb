# frozen_string_literal: true

require 'rails_helper'

describe ExpenseCreatorsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/expense_creators').to route_to('expense_creators#index')
    end

    it 'routes to #show' do
      expect(get: '/expense_creators/1').to route_to('expense_creators#show', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/expense_creators').to route_to('expense_creators#create')
    end

    it 'routes to #download_csv_template' do
      expect(get: '/expense_creators/download_csv_template').to route_to('expense_creators#download_csv_template')
    end
  end
end

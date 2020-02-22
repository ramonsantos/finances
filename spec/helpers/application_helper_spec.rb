# frozen_string_literal: true

require 'rails_helper'

describe ApplicationHelper, type: :helper do
  describe '.current_year' do
    before { Timecop.freeze(2019, 6, 6) }

    after { Timecop.return }

    it 'returns current year' do
      expect(current_year).to eq('2019')
    end
  end
end

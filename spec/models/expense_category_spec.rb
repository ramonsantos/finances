# frozen_string_literal: true

require 'rails_helper'

describe ExpenseCategory, type: :model do
  describe 'validations' do
    context 'when presense_of' do
      context 'when true' do
        it { is_expected.to validate_presence_of(:name) }
      end

      context 'when false' do
        it { is_expected.not_to validate_presence_of(:description) }
      end
    end
  end
end

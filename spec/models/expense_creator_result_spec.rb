# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExpenseCreatorResult, type: :model do
  context 'associations' do
    context 'when belong_to' do
      it { is_expected.to belong_to(:expense_creator) }
    end
  end

  context 'validations' do
    context 'when presense_of' do
      context 'when true' do
        it { is_expected.to validate_presence_of(:expense_creator) }
        it { is_expected.to validate_presence_of(:raw_content) }
        it { is_expected.to validate_presence_of(:details) }
      end

      context 'when false' do
        it { is_expected.not_to validate_presence_of(:success) }
      end
    end
  end
end

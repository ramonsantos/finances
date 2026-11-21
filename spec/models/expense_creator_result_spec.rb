# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExpenseCreatorResult, type: :model do
  describe 'associations' do
    context 'when belong_to' do
      it { is_expected.to belong_to(:expense_creator).counter_cache(:expense_creator_results_count) }
    end
  end

  describe 'validations' do
    context 'when validate presence_of' do
      it do
        expect(subject).to validate_presence_of(:raw_content)
        expect(subject).to validate_presence_of(:details)
      end
    end
  end
end

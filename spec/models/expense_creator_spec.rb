# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExpenseCreator, type: :model do
  describe 'associations' do
    context 'when have_many' do
      it { is_expected.to have_many(:expense_creator_results).dependent(:destroy) }
    end
  end

  describe 'validations' do
    context 'when validate presence_of' do
      it { is_expected.to validate_presence_of(:date) }
    end

    context 'when define enum' do
      it do
        expect(subject).to define_enum_for(:status).with_values(
          queued: 0,
          processing: 1,
          finished: 2,
          failed: 3
        )
      end
    end
  end

  describe '#import_result_summary' do
    let(:expense_creator) { create(:expense_creator) }
    let(:expected_result) { { total: 3, successes: 2, errors: 1 } }

    before do
      create(:expense_creator_result, expense_creator:, success: true)
      create(:expense_creator_result, expense_creator:, success: true)
      create(:expense_creator_result, expense_creator:, success: false)
    end

    it 'returns processed, success and error counts' do
      expect(expense_creator.import_result_summary).to eq(expected_result)
    end
  end

  describe '#process_csv!' do
    let(:expense_creator) { create(:expense_creator) }

    before do
      allow(CreateExpensesFromCsvService).to receive(:call)
    end

    it 'delegates to CreateExpensesFromCsvService' do
      expense_creator.process_csv!

      expect(CreateExpensesFromCsvService).to have_received(:call).with(expense_creator: expense_creator)
    end
  end
end

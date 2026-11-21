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

  describe '#import_row_values' do
    let(:expected_result) { ['01/01/2025', 'Mercado', '10,00', nil, nil, nil, nil, nil] }

    context 'when raw_content is JSON' do
      let(:expense_creator_result) do
        build(
          :expense_creator_result,
          raw_content: { date: '01/01/2025', description: 'Mercado', amount: '10,00' }.to_json
        )
      end

      it 'returns cell values in column order' do
        expect(expense_creator_result.import_row_values).to eq(expected_result)
      end
    end

    context 'when raw_content is legacy hash string' do
      let(:expense_creator_result) do
        build(
          :expense_creator_result,
          raw_content: '{:date=>"01/01/2025", :description=>"Mercado", :amount=>"10,00"}'
        )
      end

      it 'returns cell values in column order' do
        expect(expense_creator_result.import_row_values).to eq(expected_result)
      end
    end
  end
end

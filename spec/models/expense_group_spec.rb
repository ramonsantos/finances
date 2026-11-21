# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExpenseGroup, type: :model do
  describe 'associations' do
    context 'when have_many' do
      it { is_expected.to have_many(:expenses).dependent(:restrict_with_error) }
    end
  end

  describe 'validations' do
    context 'when validate presence_of' do
      it { is_expected.to validate_presence_of(:name) }
    end

    context 'when validate uniqueness_of' do
      subject { create(:expense_group, name: 'Pessoal') }

      it { is_expected.to validate_uniqueness_of(:name).ignoring_case_sensitivity }
    end

    context 'when custom validators' do
      context 'when success' do
        context 'when name has extra spaces' do
          let(:name) { '  pessoal  ' }
          let(:expected_name) { 'Pessoal' }

          it 'normalizes name with upcase_first' do
            group = create(:expense_group, name: name)

            expect(group.name).to eq(expected_name)
          end
        end
      end
    end
  end
end

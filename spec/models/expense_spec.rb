# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Expense, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:place) }
    it { is_expected.to belong_to(:expense_group) }
  end

  describe 'validations' do
    context 'when presense_of' do
      context 'when true' do
        it { is_expected.to validate_presence_of(:description) }
        it { is_expected.to validate_presence_of(:amount) }
        it { is_expected.to validate_presence_of(:date) }
        it { is_expected.to validate_presence_of(:category) }
        it { is_expected.to validate_presence_of(:user) }
        it { is_expected.to validate_presence_of(:place) }
        it { is_expected.to validate_presence_of(:expense_group) }
      end

      context 'when false' do
        it { is_expected.not_to validate_presence_of(:fixed) }
        it { is_expected.not_to validate_presence_of(:remark) }
      end
    end

    context 'when enum' do
      let(:category) do
        {
          food:      'Alimentação',
          transport: 'Transporte',
          health:    'Saúde',
          pet:       'Pet',
          education: 'Educação'
        }
      end

      it do
        expect(subject).to define_enum_for(:category).with_values(category).backed_by_column_of_type(:string)
      end
    end
  end
end

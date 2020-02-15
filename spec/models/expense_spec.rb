# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Expense, type: :model do
  describe 'validations' do
    context 'when presense_of' do
      it { is_expected.to validate_presence_of(:description) }
      it { is_expected.to validate_presence_of(:amount) }
      it { is_expected.to validate_presence_of(:date) }
      it { is_expected.to validate_presence_of(:fixed) }
      it { is_expected.to validate_presence_of(:category) }

      it { is_expected.not_to validate_presence_of(:remark) }
    end

    context 'when enum' do
      let(:category) do
        {
          food:      'Food',
          transport: 'Transport',
          health:    'Health',
          pet:       'Pet',
          education: 'Education'
        }
      end

      it do
        expect(subject).to define_enum_for(:category).with_values(category).backed_by_column_of_type(:string)
      end
    end
  end
end

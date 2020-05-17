# frozen_string_literal: true

require 'rails_helper'

describe ExpenseCategory, type: :model do
  context 'associations' do
    context 'when belong_to' do
      it { is_expected.to belong_to(:user) }
    end

    context 'when have_many' do
      it { is_expected.to have_many(:expenses).dependent(:restrict_with_exception) }
    end
  end

  context 'validations' do
    context 'when presense' do
      context 'when true' do
        it { is_expected.to validate_presence_of(:user) }
        it { is_expected.to validate_presence_of(:name) }
      end

      context 'when false' do
        it { is_expected.not_to validate_presence_of(:description) }
      end
    end

    context 'when uniqueness' do
      subject { build(:expense_category) }

      it { is_expected.to validate_uniqueness_of(:name).ignoring_case_sensitivity }
    end
  end
end

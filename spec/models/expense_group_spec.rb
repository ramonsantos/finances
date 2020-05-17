# frozen_string_literal: true

require 'rails_helper'

describe ExpenseGroup, type: :model do
  describe 'associations' do
    context 'when belong_to' do
      it { is_expected.to belong_to(:user) }
    end

    context 'when have_many' do
      it { is_expected.to have_many(:expenses).dependent(:restrict_with_exception) }
    end
  end

  describe 'validations' do
    context 'when presence' do
      it { is_expected.to validate_presence_of(:name) }
      it { is_expected.to validate_presence_of(:user) }
    end

    context 'when uniqueness' do
      subject { build(:expense_group) }

      it { is_expected.to validate_uniqueness_of(:name).ignoring_case_sensitivity }
    end
  end
end

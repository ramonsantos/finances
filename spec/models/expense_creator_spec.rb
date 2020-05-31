# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExpenseCreator, type: :model do
  describe 'associations' do
    context 'when belong_to' do
      it { is_expected.to belong_to(:user) }
    end

    context 'when have_many' do
      it { is_expected.to have_many(:expense_creator_results).dependent(:restrict_with_exception) }
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:date) }
    it { is_expected.to validate_presence_of(:user) }
  end

  describe '#create_from_csv' do
    let(:csv_file_path) { 'spec/fixtures/expenses.csv' }
    let!(:expense_creator) { create(:expense_creator) }

    it 'creates two ExpenseCreatorResult' do
      expect do
        expense_creator.create_from_csv(csv_file_path)
      end.to change(ExpenseCreatorResult, :count).by(2)
    end
  end
end

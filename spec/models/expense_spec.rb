# frozen_string_literal: true

require 'rails_helper'

describe Expense, type: :model do
  let!(:expense_group_work) { create(:expense_group) }
  let!(:expense_group_home) { create(:expense_group_home) }

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:place).counter_cache(true) }
    it { is_expected.to belong_to(:expense_group).counter_cache(true) }
    it { is_expected.to belong_to(:expense_category).counter_cache(true) }
  end

  describe 'validations' do
    context 'when presense_of' do
      context 'when true' do
        it { is_expected.to validate_presence_of(:description) }
        it { is_expected.to validate_presence_of(:amount) }
        it { is_expected.to validate_presence_of(:date) }
        it { is_expected.to validate_presence_of(:user) }
        it { is_expected.to validate_presence_of(:place) }
        it { is_expected.to validate_presence_of(:expense_category) }
        it { is_expected.to validate_presence_of(:expense_group) }
      end

      context 'when false' do
        it { is_expected.not_to validate_presence_of(:fixed) }
        it { is_expected.not_to validate_presence_of(:remark) }
      end
    end
  end

  describe 'scopes' do
    before do
      create(:expense)
      create(:expense_other_month)
      create(:expense, amount: 2.42)
    end

    describe '.fetch_by_month' do
      let(:expeses) { described_class.fetch_by_month(User.first, Date.parse('2020-02-21')) }

      it 'returns one expense from February' do
        expect(expeses.count).to eq(2)
        expect(expeses.first.date).to eq(Date.parse('2020-02-15'))
      end
    end

    describe '.fetch_expenses_grouped_by_groups' do
      let!(:expense_home_1) { create(:expense, expense_group_id: expense_group_home.id) }
      let!(:expense_home_2) { create(:expense, expense_group_id: expense_group_home.id) }
      let(:result) { described_class.fetch_expenses_grouped_by_groups(User.first, Date.parse('2020-02-21')) }

      it { expect(result.count).to eq(2) }
      it { expect(result['Pessoal'].count).to eq(2) }
      it { expect(result['Casa']).to eq([expense_home_1, expense_home_2]) }
    end

    describe '.fetch_total_monthly_spend' do
      let(:total) { described_class.fetch_total_monthly_spend(User.first, Date.parse('2020-02-21')) }

      it 'returns total monthly spend' do
        expect(total).to eq(23.92)
      end
    end
  end

  describe '.group_for_report' do
    let(:result) { described_class.group_for_report(User.first, Date.parse('2020-02-21')) }
    let(:expense_category) { ExpenseCategory.find_by(name: 'Saúde') }

    let(:expected_result) do
      [
        {
          expense_group_name: 'Trabalho',
          total: 64.56,
          categories: [{ name: 'Alimentação', percent_total: 100.0 }]
        },
        {
          expense_group_name: 'Casa',
          total: 91.44,
          categories: [{ name: 'Saúde', percent_total: 93.45 }, { name: 'Alimentação', percent_total: 6.55 }]
        }
      ]
    end

    before do
      create(:expense, expense_group_id: expense_group_work.id, amount: 12.56)
      create(:expense, expense_group_id: expense_group_work.id, amount: 52.0)
      create(:expense, expense_group_id: expense_group_home.id, amount: 85.45, expense_category_id: expense_category.id)
      create(:expense, expense_group_id: expense_group_home.id, amount: 5.99)
    end

    it { expect(result).to eq(expected_result) }
  end
end

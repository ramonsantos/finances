# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Expense, type: :model do
  describe 'associations' do
    context 'when belong_to' do
      it do
        expect(subject).to belong_to(:expense_category).counter_cache(true)
        expect(subject).to belong_to(:payment_method).counter_cache(true)
      end
    end
  end

  describe 'validations' do
    context 'when validate presence_of' do
      it do
        expect(subject).to validate_presence_of(:description)
        expect(subject).to validate_presence_of(:amount)
        expect(subject).to validate_presence_of(:date)
      end
    end

    context 'when validate comparison_of' do
      it { is_expected.to validate_comparison_of(:amount).is_greater_than_or_equal_to(0.01) }
    end

    context 'when amount is submitted with comma decimal separator' do
      let(:expense_category) { create(:expense_category) }
      let(:payment_method) { create(:payment_method) }
      let(:expense) do
        build(
          :expense,
          amount: '2,00',
          expense_category: expense_category,
          payment_method: payment_method
        )
      end

      it 'is valid' do
        expect(expense).to be_valid
      end
    end
  end

  describe '.for_month' do
    let(:category) { create(:expense_category) }
    let(:payment_method) { create(:payment_method, name: 'Pix Nubank') }
    let!(:in_month) { create(:expense, date: Date.new(2025, 3, 10), expense_category: category, payment_method: payment_method) }

    before do
      create(:expense, date: Date.new(2025, 2, 28), expense_category: category, payment_method: payment_method)
    end

    it 'returns expenses in the month' do
      expect(described_class.for_month(Date.new(2025, 3, 15))).to contain_exactly(in_month)
    end
  end

  describe '.category_report_data' do
    let(:category) { create(:expense_category, name: 'Alimentação') }
    let(:payment_method) { create(:payment_method, name: 'Swile') }
    let(:month) { Date.new(2025, 1, 15) }

    before do
      create(:expense, amount: 40, date: month, expense_category: category, payment_method: payment_method)
      create(:expense, amount: 60, date: month, expense_category: category, payment_method: payment_method)
    end

    it 'returns category totals and percentages' do
      data = described_class.category_report_data(month)
      row = data.find { |entry| entry[:name] == 'Alimentação' }

      expect(row[:total]).to eq(100)
      expect(row[:percent_total]).to eq(100.0)
    end
  end

  describe '.payment_method_report_data' do
    let(:category) { create(:expense_category) }
    let(:payment_method) { create(:payment_method, name: 'Cartão BB') }
    let(:month) { Date.new(2025, 1, 15) }

    before do
      create(:expense, amount: 30, date: month, expense_category: category, payment_method: payment_method)
    end

    it 'returns payment method totals' do
      data = described_class.payment_method_report_data(month)
      row = data.find { |entry| entry[:name] == 'Cartão BB' }

      expect(row[:count]).to eq(1)
      expect(row[:total]).to eq(30)
    end
  end
end

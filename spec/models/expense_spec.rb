# frozen_string_literal: true

require "rails_helper"

RSpec.describe Expense, type: :model do
  describe "associations" do
    context "when belong_to" do
      it do
        expect(subject).to belong_to(:expense_category).counter_cache(true)
        expect(subject).to belong_to(:expense_group).counter_cache(true)
      end
    end
  end

  describe "validations" do
    context "when validate presence_of" do
      it do
        expect(subject).to validate_presence_of(:description)
        expect(subject).to validate_presence_of(:amount)
        expect(subject).to validate_presence_of(:date)
      end
    end

    context "when validate numericality_of" do
      it { is_expected.to validate_numericality_of(:amount).is_greater_than_or_equal_to(0.01) }
    end
  end

  describe ".for_month" do
    let(:category) { create(:expense_category) }
    let(:group) { create(:expense_group) }
    let(:month) { Date.new(2025, 3, 15) }
    let!(:in_month) { create(:expense, date: Date.new(2025, 3, 10), expense_category: category, expense_group: group) }
    let(:expected_result) { [in_month] }

    before { create(:expense, date: Date.new(2025, 2, 28), expense_category: category, expense_group: group) }

    it "returns expenses within the month" do
      expect(described_class.for_month(month)).to match_array(expected_result)
    end
  end

  describe ".for_month_ordered" do
    let(:category) { create(:expense_category) }
    let(:group) { create(:expense_group) }
    let(:month) { Date.new(2025, 3, 15) }
    let!(:later) { create(:expense, date: Date.new(2025, 3, 20), expense_category: category, expense_group: group) }
    let!(:earlier) { create(:expense, date: Date.new(2025, 3, 5), expense_category: category, expense_group: group) }
    let(:expected_result) { [earlier, later] }

    it "returns expenses ordered by date" do
      expect(described_class.for_month_ordered(month).to_a).to eq(expected_result)
    end
  end

  describe ".total_for_month" do
    let(:category) { create(:expense_category) }
    let(:group) { create(:expense_group) }
    let(:month) { Date.new(2025, 1, 15) }
    let(:expected_result) { 30 }

    before do
      create(:expense, amount: 10, date: Date.new(2025, 1, 5), expense_category: category, expense_group: group)
      create(:expense, amount: 20, date: Date.new(2025, 1, 10), expense_category: category, expense_group: group)
    end

    it "sums amounts for the month" do
      expect(described_class.total_for_month(month)).to eq(expected_result)
    end
  end

  describe ".grouped_for_report" do
    let(:category) { create(:expense_category) }
    let(:group_a) { create(:expense_group, name: "Grupo A") }
    let(:group_b) { create(:expense_group, name: "Grupo B") }
    let(:month) { Date.new(2025, 4, 1) }

    before do
      create(:expense, date: month, expense_category: category, expense_group: group_a)
      create(:expense, date: month, expense_category: category, expense_group: group_b)
    end

    it "groups expenses by group name" do
      result = described_class.grouped_for_report(month)

      expect(result.keys).to contain_exactly("Grupo A", "Grupo B")
      expect(result["Grupo A"].size).to eq(1)
    end
  end

  describe ".categories_report_data" do
    let(:category_a) { build_stubbed(:expense_category, name: "Alimentação") }
    let(:category_b) { build_stubbed(:expense_category, name: "Transporte") }
    let(:expense_a) { build_stubbed(:expense, amount: 30, expense_category: category_a) }
    let(:expense_b) { build_stubbed(:expense, amount: 70, expense_category: category_b) }
    let(:total_amount) { 100.0 }

    let(:by_category) do
      {
        category_a => [expense_a],
        category_b => [expense_b]
      }
    end

    let(:expected_result) do
      [
        { name: "Alimentação", percent_total: 30.0 },
        { name: "Transporte", percent_total: 70.0 }
      ]
    end

    it "returns category names with percent of the group total" do
      expect(described_class.categories_report_data(by_category, total_amount)).to eq(expected_result)
    end
  end

  describe ".report_data" do
    let(:category) { create(:expense_category, name: "Alimentação") }
    let(:group) { create(:expense_group, name: "Pessoal") }
    let(:month) { Date.new(2025, 5, 1) }
    let(:expected_group_name) { "Pessoal" }
    let(:expected_total) { 100.0 }

    before do
      create(:expense, amount: 40, date: month, expense_category: category, expense_group: group)
      create(:expense, amount: 60, date: month, expense_category: category, expense_group: group)
    end

    it "returns grouped totals and category percentages" do
      data = described_class.report_data(month)
      group_data = data.find { |row| row[:expense_group_name] == expected_group_name }

      expect(group_data[:total]).to eq(expected_total)
      expect(group_data[:categories].first[:percent_total]).to eq(100.0)
    end
  end

  describe ".percent_of" do
    context "when total is zero" do
      let(:expected_result) { 0.0 }

      it "returns zero" do
        expect(described_class.percent_of(0, 50)).to eq(expected_result)
      end
    end

    context "when total is positive" do
      let(:expected_result) { 25.0 }

      it "returns the rounded percentage" do
        expect(described_class.percent_of(200, 50)).to eq(expected_result)
      end
    end
  end
end

# frozen_string_literal: true

class Expense < ApplicationRecord
  include NormalizesCurrency

  normalizes_currency :amount

  belongs_to :expense_category, counter_cache: true
  belongs_to :expense_group, counter_cache: true

  validates :description, presence: true
  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0.01 }
  validates :date, presence: true

  scope :for_month, ->(date) { where(date: date.all_month) }

  scope :for_month_ordered, lambda { |date|
    for_month(date).order(:date).includes(:expense_group, :expense_category)
  }

  def self.total_for_month(date)
    for_month(date).sum(:amount)
  end

  def self.grouped_for_report(date)
    for_month(date).includes(:expense_group, :expense_category).group_by { |e| e.expense_group.name }
  end

  def self.report_data(date)
    grouped_for_report(date).map do |name, expenses|
      total = expenses.sum(&:amount)

      {
        expense_group_name: name,
        total: total,
        categories: categories_report_data(expenses.group_by(&:expense_category), total)
      }
    end
  end

  def self.categories_report_data(by_category, total_amount)
    by_category.map do |category, category_expenses|
      portion = category_expenses.sum(&:amount)

      {
        name: category.name,
        percent_total: percent_of(total_amount, portion)
      }
    end
  end

  def self.percent_of(total, portion)
    return 0.0 if total.zero?

    ((portion / total.to_f) * 100).round(2)
  end
end

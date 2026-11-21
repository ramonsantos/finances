# frozen_string_literal: true

class Expense < ApplicationRecord
  include NormalizesCurrency

  normalizes_currency :amount

  belongs_to :expense_category, counter_cache: true
  belongs_to :payment_method, counter_cache: true

  validates :description, presence: true
  validates :amount, presence: true, comparison: { greater_than_or_equal_to: 0.01 }
  validates :date, presence: true

  scope :for_month, ->(date) { where(date: date.all_month) }

  scope :for_month_ordered, lambda { |date|
    for_month(date).order(:date).includes(:expense_category, :payment_method)
  }

  def self.total_for_month(date)
    for_month(date).sum(:amount)
  end

  def self.category_report_data(date)
    expenses = for_month(date).includes(:expense_category)
    total = expenses.sum(&:amount)

    expenses.group_by(&:expense_category).map do |category, category_expenses|
      portion = category_expenses.sum(&:amount)

      {
        name: category.name,
        total: portion,
        percent_total: percent_of(total, portion)
      }
    end.sort_by { |entry| -entry[:total] }
  end

  def self.payment_method_report_data(date)
    expenses = for_month(date).includes(:payment_method)
    total = expenses.sum(&:amount)

    expenses.group_by(&:payment_method).map do |payment_method, method_expenses|
      portion = method_expenses.sum(&:amount)

      {
        name: payment_method.name,
        count: method_expenses.size,
        total: portion,
        percent_total: percent_of(total, portion)
      }
    end.sort_by { |entry| -entry[:total] }
  end

  def self.percent_of(total, portion)
    return 0.0 if total.zero?

    ((portion / total.to_f) * 100).round(2)
  end
end

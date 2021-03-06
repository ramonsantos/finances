# frozen_string_literal: true

class Expense < ApplicationRecord
  paginates_per 20

  belongs_to :user
  belongs_to :place,            counter_cache: true
  belongs_to :expense_group,    counter_cache: true
  belongs_to :expense_category, counter_cache: true

  validates :description,      presence: true
  validates :amount,           presence: true
  validates :date,             presence: true
  validates :expense_category, presence: true
  validates :user,             presence: true
  validates :place,            presence: true
  validates :expense_group,    presence: true
  validates :remark,           presence: false
  validates :fixed,            presence: false

  encrypts :description
  encrypts :amount, type: :float

  scope :fetch_by_month, ->(user, date) { where(user: user, date: date.beginning_of_month..date.end_of_month) }

  scope :fetch_by_month_order_by_date, lambda { |user, date|
    fetch_by_month(user, date).order(:date).includes(:place, :expense_group, :expense_category)
  }

  scope :fetch_expenses_grouped_by_groups, lambda { |user, date|
    fetch_by_month(user, date).includes(:expense_group, :expense_category).group_by do |expense|
      expense.expense_group.name
    end
  }

  scope :fetch_total_monthly_spend, lambda { |user, date|
    fetch_by_month(user, date).reduce(0) do |sum, element|
      sum + element.amount
    end
  }

  class << self
    def group_for_report(user, date)
      fetch_expenses_grouped_by_groups(user, date).map do |name, expenses|
        total_expense_amount = total(expenses)

        {
          expense_group_name: name,
          total: total_expense_amount,
          categories: categories_data(expenses.group_by(&:expense_category), total_expense_amount)
        }
      end
    end

    private

    def categories_data(expenses_grouped_by_catogory, total_expense_amount)
      expenses_grouped_by_catogory.map do |expense_category, expenses|
        {
          name: expense_category.name,
          percent_total: percent(total_expense_amount, total(expenses))
        }
      end
    end

    def total(expenses)
      expenses.inject(0) { |sum, e| sum + e.amount }
    end

    def percent(total, portion)
      ((portion / total) * 100).round(2)
    end
  end
end

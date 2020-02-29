# frozen_string_literal: true

class Expense < ApplicationRecord
  paginates_per 20

  belongs_to :user
  belongs_to :place
  belongs_to :expense_group

  validates :description,   presence: true
  validates :amount,        presence: true
  validates :date,          presence: true
  validates :category,      presence: true
  validates :user,          presence: true
  validates :place,         presence: true
  validates :expense_group, presence: true
  validates :remark,        presence: false
  validates :fixed,         presence: false

  enum category: {
    food:      'Alimentação',
    transport: 'Transporte',
    health:    'Saúde',
    pet:       'Pet',
    education: 'Educação'
  }

  scope :fetch_by_month, lambda { |user, date|
    where(user: user, date: date.beginning_of_month..date.end_of_month)
      .order(:date).includes(:place, :expense_group)
  }

  scope :fetch_total_monthly_spend, lambda { |user, date|
    where(user: user, date: date.beginning_of_month..date.end_of_month).sum(:amount)
  }

  scope :fetch_expenses_grouped_by_groups, lambda { |user, date|
    where(user: user, date: date.beginning_of_month..date.end_of_month)
      .includes(:expense_group).group_by { |expense| expense.expense_group.name }
  }

  class << self
    def group_for_report(user, date)
      fetch_expenses_grouped_by_groups(user, date).map do |name, expenses|
        {
          expense_group_name: name,
          total: total(expenses),
          categories: categories_data(expenses.group_by(&:category))
        }
      end
    end

    private

    def categories_data(expenses_grouped_by_catogory)
      expenses_grouped_by_catogory.map do |catg_name, expenses|
        [catg_name, total(expenses)]
      end
    end

    def total(expenses)
      expenses.inject(0) { |sum, e| sum + e.amount }
    end
  end
end

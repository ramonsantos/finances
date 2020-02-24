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

  scope :fetch_by_month, lambda { |current_user, date|
    where(user: current_user, date: date.beginning_of_month..date.end_of_month)
      .order(:date).includes(:place, :expense_group)
  }

  scope :fetch_total_monthly_spend, lambda { |current_user, date|
    where(user: current_user, date: date.beginning_of_month..date.end_of_month).sum(:amount)
  }
end

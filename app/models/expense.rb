# frozen_string_literal: true

class Expense < ApplicationRecord
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

  enum category: {
    food:      'Alimentação',
    transport: 'Transporte',
    health:    'Saúde',
    pet:       'Pet',
    education: 'Educação'
  }
end

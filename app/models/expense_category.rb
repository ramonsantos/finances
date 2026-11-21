# frozen_string_literal: true

class ExpenseCategory < ApplicationRecord
  has_many :expenses, dependent: :restrict_with_error

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  normalizes :name, with: ->(name) { name.to_s.strip.upcase_first }
end
# frozen_string_literal: true

class ExpenseCategory < ApplicationRecord
  validates :name,        presence: true
  validates :description, presence: false
end

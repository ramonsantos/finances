# frozen_string_literal: true

class Expense < ApplicationRecord
  validates :description, presence: true
  validates :amount,      presence: true
  validates :date,        presence: true
  validates :fixed,       presence: true
end

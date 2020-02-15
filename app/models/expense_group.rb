# frozen_string_literal: true

class ExpenseGroup < ApplicationRecord
  validates :name, presence: true
end

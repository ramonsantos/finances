# frozen_string_literal: true

class ExpenseCreatorResult < ApplicationRecord
  belongs_to :expense_creator

  validates :expense_creator, presence: true
  validates :raw_content,     presence: true
  validates :success,         presence: true
  validates :details,         presence: true
end

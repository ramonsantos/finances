# frozen_string_literal: true

class ExpenseCreatorResult < ApplicationRecord
  paginates_per 20

  belongs_to :expense_creator

  validates :expense_creator, presence: true
  validates :raw_content,     presence: true
  validates :details,         presence: true
  validates :success,         presence: false
end

# frozen_string_literal: true

class ExpenseCreator < ApplicationRecord
  belongs_to :user
  has_many :expense_creator_results, dependent: :restrict_with_exception

  validates :user, presence: true
  validates :date, presence: true
end

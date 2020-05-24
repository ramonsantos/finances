# frozen_string_literal: true

class ExpenseCreator < ApplicationRecord
  paginates_per 20

  belongs_to :user
  has_many :expense_creator_results, dependent: :restrict_with_exception

  validates :user, presence: true
  validates :date, presence: true

  def create_from_csv!(csv_file_path)
    CreateExpensesFromCsv.new(self, csv_file_path).create_expenses
  end
end

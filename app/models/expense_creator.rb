# frozen_string_literal: true

class ExpenseCreator < ApplicationRecord
  has_many :expense_creator_results, dependent: :destroy

  has_one_attached :csv_file

  enum :status, { queued: 0, processing: 1, finished: 2, failed: 3 }, validate: true

  validates :date, presence: true

  def process_csv!
    CreateExpensesFromCsvService.call(expense_creator: self)
  end
end

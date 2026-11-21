# frozen_string_literal: true

class ImportExpensesCsvJob < ApplicationJob
  queue_as :default

  def perform(expense_creator)
    expense_creator.processing!
    expense_creator.process_csv!
    expense_creator.finished!
  rescue StandardError
    expense_creator.failed!
    raise
  end
end
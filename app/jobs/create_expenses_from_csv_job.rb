# frozen_string_literal: true

class CreateExpensesFromCsvJob < ApplicationJob
  queue_as :create_expenses_by_csv

  def perform(data)
    raise if file_path(data).blank?
    raise if user(data).blank?

    CreateExpensesFromCsv.new(user, file_path).create_expenses
  end

  private

  def file_path(data = nil)
    @file_path ||= data.try(:fetch, :file_path)
  end

  def user(data = nil)
    @user ||= fetch_user(data.try(:fetch, :user_id))
  end

  def fetch_user(user_id)
    return nil if user_id.blank?

    User.find(user_id)
  end
end

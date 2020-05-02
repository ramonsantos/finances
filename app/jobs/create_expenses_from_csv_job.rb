# frozen_string_literal: true

class CreateExpensesFromCsvJob < ApplicationJob
  queue_as :create_expenses_by_csv

  def perform(data)
    raise if blob_key(data).blank?
    raise if user(data).blank?

    blob.open(tmpdir: Dir.tmpdir) do |file|
      CreateExpensesFromCsv.new(user, file.path).create_expenses
    end
  end

  private

  def blob_key(data = nil)
    @blob_key ||= data.try(:fetch, :blob_key)
  end

  def user(data = nil)
    @user ||= fetch_user(data.try(:fetch, :user_id))
  end

  def fetch_user(user_id)
    return nil if user_id.blank?

    User.find(user_id)
  end

  def blob
    @blob ||= fetch_blob
  end

  def fetch_blob
    ActiveStorage::Blob.find_by(key: blob_key)
  end
end

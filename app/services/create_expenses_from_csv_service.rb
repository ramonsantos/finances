# frozen_string_literal: true

require 'csv'

class CreateExpensesFromCsvService < ApplicationService
  def initialize(expense_creator:)
    super()
    @expense_creator = expense_creator
    @expense_categories = {}
    @expense_groups = {}
  end

  private

  def call
    @expense_creator.csv_file.open do |file|
      CSV.foreach(file.path, headers: true) { |row| create_expense(row) }
    end
  end

  def create_expense(row)
    Expense.create!(attributes_from_row(row))
    record_result(row, true, I18n.t('services.create_expenses_from_csv_service.details.success'))
  rescue StandardError => error
    record_result(row, false, I18n.t('services.create_expenses_from_csv_service.details.error', error_message: error.message))
  end

  def attributes_from_row(row)
    {
      description: require_field(row, :description),
      amount: parse_amount(row_content(row, :amount)),
      date: parse_date(row_content(row, :date)),
      expense_category: expense_category(row_content(row, :expense_category)),
      expense_group: expense_group(row_content(row, :expense_group)),
      fixed: parse_fixed?(row_content(row, :fixed)),
      remark: row_content(row, :remark)
    }
  end

  def record_result(row, success, details)
    ExpenseCreatorResult.create!(
      expense_creator: @expense_creator,
      raw_content: row.to_s.strip,
      success: success,
      details: details
    )
  end

  def require_field(row, column)
    value = row_content(row, column)
    raise(StandardError, error_message(:cant_be_blank, column)) if value.blank?

    value
  end

  def parse_amount(value)
    raise(StandardError, error_message(:cant_be_blank, :amount)) if value.blank?

    amount = value.to_s.gsub(/[R$ .]/, '').tr(',', '.').to_d
    raise(StandardError, error_message(:invalid_format, :amount)) if amount < 0.01

    amount
  end

  def parse_date(value)
    raise(StandardError, error_message(:cant_be_blank, :date)) if value.blank?

    Date.strptime(value.strip, '%d/%m/%y')
  rescue ArgumentError
    raise(StandardError, error_message(:invalid_format, :date))
  end

  def expense_category(value)
    raise(StandardError, error_message(:cant_be_blank, :expense_category)) if value.blank?

    @expense_categories[value] ||= ExpenseCategory.where('LOWER(name) = ?', value.downcase).first!
  rescue ActiveRecord::RecordNotFound
    raise(StandardError, error_message(:nonexistent, :expense_category))
  end

  def expense_group(value)
    raise(StandardError, error_message(:cant_be_blank, :expense_group)) if value.blank?

    @expense_groups[value] ||= ExpenseGroup.where('LOWER(name) = ?', value.downcase).first!
  rescue ActiveRecord::RecordNotFound
    raise(StandardError, error_message(:nonexistent, :expense_group))
  end

  def parse_fixed?(value)
    raise(StandardError, error_message(:cant_be_blank, :fixed)) if value.blank?

    value.to_s.casecmp('sim').zero?
  end

  def row_content(row, column)
    row[header_for(column)]
  end

  def header_for(column)
    I18n.t("services.create_expenses_from_csv_service.csv_headers.#{column}")
  end

  def error_message(type, column)
    I18n.t(
      "services.create_expenses_from_csv_service.error_messages.#{type}",
      column: header_for(column)
    )
  end
end

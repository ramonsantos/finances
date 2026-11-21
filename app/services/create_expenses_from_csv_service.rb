# frozen_string_literal: true

require 'csv'

class CreateExpensesFromCsvService < ApplicationService
  IMPORTABLE_COLUMNS = [
    :date,
    :description,
    :amount,
    :expense_category,
    :payment_method,
    :essential,
    :fixed,
    :remark
  ].freeze

  def initialize(expense_creator:)
    super()
    @expense_creator = expense_creator
    @expense_categories = {}
    @payment_methods = {}
  end

  private

  def call
    @expense_creator.csv_file.open do |file|
      import_csv(file.path)
    end
  end

  def import_csv(path)
    CSV.foreach(path, headers: true) { |row| process_row(row_to_hash(row)) }
  end

  def row_to_hash(row)
    IMPORTABLE_COLUMNS.index_with { |column| row[header_for(column)] }
  end

  def process_row(row_hash)
    return if skip_row?(row_hash)

    Expense.create!(attributes_from_row(row_hash))
    record_result(row_hash, true, I18n.t('services.create_expenses_from_spreadsheet_service.details.success'))
  rescue StandardError => error
    record_result(row_hash, false, I18n.t('services.create_expenses_from_spreadsheet_service.details.error', error_message: error.message))
  end

  def skip_row?(row_hash)
    row_hash[:date].blank? || row_hash[:amount].blank?
  end

  def attributes_from_row(row_hash)
    {
      description: require_field(row_hash, :description),
      amount: parse_amount(row_hash[:amount]),
      date: parse_date(row_hash[:date]),
      expense_category: expense_category(row_hash[:expense_category]),
      payment_method: payment_method(row_hash[:payment_method]),
      essential: parse_yes_no_field(row_hash, :essential),
      fixed: parse_yes_no_field(row_hash, :fixed),
      remark: row_hash[:remark].to_s.strip.presence
    }
  end

  def record_result(row_hash, success, details)
    ExpenseCreatorResult.create!(
      expense_creator: @expense_creator,
      raw_content: row_hash.compact_blank.transform_keys(&:to_s).to_json,
      success: success,
      details: details
    )
  end

  def require_field(row_hash, column)
    value = row_hash[column].to_s.strip
    raise(StandardError, error_message(:cant_be_blank, column)) if value.blank?

    value
  end

  def parse_amount(value)
    raise(StandardError, error_message(:cant_be_blank, :amount)) if value.blank?

    raw = value.to_s.strip.gsub(/[R$\s]/, '')
    amount = if raw.include?(',')
               raw.delete('.').tr(',', '.').to_d
             else
               raw.to_d
             end
    raise(StandardError, error_message(:invalid_format, :amount)) if amount < 0.01

    amount
  end

  def parse_date(value)
    raise(StandardError, error_message(:cant_be_blank, :date)) if value.blank?

    raw = value.is_a?(Date) ? value.strftime('%d/%m/%Y') : value.to_s.strip

    Date.strptime(raw, '%d/%m/%Y')
  rescue ArgumentError
    begin
      Date.strptime(raw, '%d/%m/%y')
    rescue ArgumentError
      raise(StandardError, error_message(:invalid_format, :date))
    end
  end

  def expense_category(value)
    raise(StandardError, error_message(:cant_be_blank, :expense_category)) if value.blank?

    name = value.to_s.strip
    @expense_categories[name] ||= ExpenseCategory.where('LOWER(name) = ?', name.downcase).first!
  rescue ActiveRecord::RecordNotFound
    raise(StandardError, error_message(:nonexistent, :expense_category))
  end

  def payment_method(value)
    raise(StandardError, error_message(:cant_be_blank, :payment_method)) if value.blank?

    name = value.to_s.strip
    @payment_methods[name] ||= PaymentMethod.where('LOWER(name) = ?', name.downcase).first!
  rescue ActiveRecord::RecordNotFound
    raise(StandardError, error_message(:nonexistent, :payment_method))
  end

  def parse_yes_no_field(row_hash, column)
    value = row_hash[column]
    raise(StandardError, error_message(:cant_be_blank, column)) if value.blank?

    str = value.to_s.strip
    return true if str.casecmp('sim').zero?
    return false if str.casecmp('não').zero? || str.casecmp('nao').zero?

    raise(StandardError, error_message(:invalid_format, column))
  end

  def header_for(column)
    I18n.t("services.create_expenses_from_spreadsheet_service.csv_headers.#{column}")
  end

  def error_message(type, column)
    I18n.t(
      "services.create_expenses_from_spreadsheet_service.error_messages.#{type}",
      column: header_for(column)
    )
  end
end

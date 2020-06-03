# frozen_string_literal: true

class CreateExpensesFromCsv
  require 'csv'

  def initialize(expense_creator, file_path)
    @expense_creator    = expense_creator
    @user               = expense_creator.user
    @file_path          = file_path
    @expense_categories = {}
    @expense_groups     = {}
    @places             = {}
  end

  def create_expenses
    CSV.foreach(@file_path, headers: true) { |row| create_expense(row) }
  end

  private

  def create_expense(row)
    Expense.create!(expense_attributes_from_row(row))

    create_expense_creator_result(row, true, I18n.t("#{base_i18n_path}.details.success"))
  rescue StandardError => e
    create_expense_creator_result(row, false, I18n.t("#{base_i18n_path}.details.error", error_message: e.message))
  end

  def expense_attributes_from_row(row)
    {
      user:             @user,
      description:      description(row_content(row, :description)),
      amount:           amount(row_content(row, :amount)),
      date:             date(row_content(row, :date)),
      expense_category: expense_category(row_content(row, :expense_category)),
      expense_group:    expense_group(row_content(row, :expense_group)),
      place:            place(row_content(row, :place)),
      fixed:            fixed(row_content(row, :fixed)),
      remark:           row_content(row, :remark)
    }
  end

  def create_expense_creator_result(row, success, details)
    ExpenseCreatorResult.create!(
      expense_creator_id: @expense_creator.id,
      raw_content:        row.to_s.strip,
      success:            success,
      details:            details
    )
  end

  def description(value)
    return value if value.present?

    raise build_error_message(:cant_be_blank, :description)
  end

  def amount(value)
    raise_if_blank_value(value, build_error_message(:cant_be_blank, :amount))

    amount = value.gsub(/[R$ .]/, '').tr(',', '.').to_f

    amount >= 0.1 ? amount : raise(build_error_message(:invalid_format, :amount))
  end

  def date(value)
    raise_if_blank_value(value, build_error_message(:cant_be_blank, :date))

    begin
      Date.strptime(value, '%d/%m/%y')
    rescue StandardError
      raise(build_error_message(:invalid_format, :date))
    end
  end

  def expense_category(value)
    raise_if_blank_value(value, build_error_message(:cant_be_blank, :expense_category))

    @expense_categories[value] ||= fetch_expense_category(value)
  end

  def fetch_expense_category(value)
    ExpenseCategory.find_by(name: value, user: @user) || raise(build_error_message(:nonexistent, :expense_category))
  end

  def expense_group(value)
    raise_if_blank_value(value, build_error_message(:cant_be_blank, :expense_group))

    @expense_groups[value] ||= fetch_expense_group(value)
  end

  def fetch_expense_group(value)
    ExpenseGroup.find_by(name: value, user: @user) || raise(build_error_message(:nonexistent, :expense_group))
  end

  def place(value)
    raise_if_blank_value(value, build_error_message(:cant_be_blank, :place))

    @places[value] ||= fetch_place(value)
  end

  def fetch_place(value)
    Place.find_by(name: value, user: @user) || raise(build_error_message(:nonexistent, :place))
  end

  def fixed(value)
    raise_if_blank_value(value, build_error_message(:cant_be_blank, :fixed))

    value.casecmp('sim').zero?
  end

  def base_i18n_path
    'models.create_expenses_from_csv'
  end

  def row_content(row, column)
    row[header_column(column)]
  end

  def header_column(column)
    I18n.t("#{base_i18n_path}.csv_headers.#{column}")
  end

  def build_error_message(error_type, column)
    I18n.t("#{base_i18n_path}.error_messages.#{error_type}", column: header_column(column))
  end

  def raise_if_blank_value(value, message)
    raise(message) if value.blank?
  end
end

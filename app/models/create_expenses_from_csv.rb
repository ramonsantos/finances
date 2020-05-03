# frozen_string_literal: true

class CreateExpensesFromCsv
  require 'csv'

  def initialize(user, file_path)
    @user = user
    @file_path = file_path
    @rows_detail = []
    @total_success = 0
    @total_errors = 0
    @expense_categories = {}
    @expense_groups = {}
    @places = {}
  end

  def create_expenses
    CSV.foreach(@file_path, headers: true) { |row| create_expense(row) }
    build_result
  end

  private

  def create_expense(row)
    Expense.create!(expense_attributes_from_row(row))

    @total_success += 1
    @rows_detail << build_row_detail(row)
  rescue StandardError => e
    @total_errors += 1
    @rows_detail << build_row_detail(row, :error, e.message)
  end

  def build_result
    {
      rows_detail: @rows_detail,
      total_success: @total_success,
      total_errors: @total_errors
    }
  end

  def expense_attributes_from_row(row)
    {
      user: @user,
      description: description(row['Descrição']),
      amount: amount(row['Valor']),
      date: date(row['Data']),
      expense_category: expense_category(row['Categoria']),
      expense_group: expense_group(row['Grupo de Despesa']),
      place: place(row['Local']),
      fixed: fixed(row['Fixo?']),
      remark: row['Observações']
    }
  end

  def build_row_detail(row, result = :success, message = nil)
    {
      row: row.to_s.strip,
      result: result,
      message: message
    }
  end

  def description(value)
    return value if value.present?

    raise 'Descrição não pode fica em branco'
  end

  def amount(value)
    raise 'Valor não pode fica em branco' if value.blank?

    amount = value.gsub(/[R$ .]/, '').tr(',', '.').to_f

    amount >= 0.1 ? amount : raise('Formato de Valor inválido')
  end

  def date(value)
    raise 'Data não pode fica em branco' if value.blank?

    begin
      Date.strptime(value, '%d/%m/%y')
    rescue StandardError
      raise('Formato de Data inválido')
    end
  end

  def expense_category(value)
    raise 'Categoria não pode fica em branco' if value.blank?

    @expense_categories[value] ||= fetch_expense_category(value)
  end

  def fetch_expense_category(value)
    ExpenseCategory.find_by(name: value, user: @user) || raise('Categoria não encontrada')
  end

  def expense_group(value)
    raise 'Grupo de Despesa não pode fica em branco' if value.blank?

    @expense_groups[value] ||= fetch_expense_group(value)
  end

  def fetch_expense_group(value)
    ExpenseGroup.find_by(name: value, user: @user) || raise('Grupo de Despesa não encontrado')
  end

  def place(value)
    raise 'Local não pode fica em branco' if value.blank?

    @places[value] ||= fetch_place(value)
  end

  def fetch_place(value)
    Place.find_by(name: value, user: @user) || raise('Local não encontrado')
  end

  def fixed(value)
    raise 'Fixo? não pode fica em branco' if value.blank?

    value.casecmp('sim').zero?
  end
end

# frozen_string_literal: true

class CreateExpensesFromCsv
  require 'csv'

  def initialize(expense_creator, file_path)
    @expense_creator = expense_creator
    @user = expense_creator.user
    @file_path = file_path
    @expense_categories = {}
    @expense_groups = {}
    @places = {}
  end

  def create_expenses
    CSV.foreach(@file_path, headers: true) { |row| create_expense(row) }
  end

  private

  def create_expense(row)
    Expense.create!(expense_attributes_from_row(row))

    create_expense_creator_result(row, true, 'Sucesso')
  rescue StandardError => e
    create_expense_creator_result(row, false, "Erro: #{e.message}")
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

  def create_expense_creator_result(row, success, details)
    ExpenseCreatorResult.create!(
      expense_creator_id: @expense_creator.id,
      raw_content: row.to_s.strip,
      success: success,
      details: details
    )
  end

  def description(value)
    return value if value.present?

    raise 'Descrição não pode fica em branco'
  end

  def amount(value)
    raise_if_blank_value(value, 'Valor não pode fica em branco')

    amount = value.gsub(/[R$ .]/, '').tr(',', '.').to_f

    amount >= 0.1 ? amount : raise('Formato de Valor inválido')
  end

  def date(value)
    raise_if_blank_value(value, 'Data não pode fica em branco')

    begin
      Date.strptime(value, '%d/%m/%y')
    rescue StandardError
      raise('Formato de Data inválido')
    end
  end

  def expense_category(value)
    raise_if_blank_value(value, 'Categoria não pode fica em branco')

    @expense_categories[value] ||= fetch_expense_category(value)
  end

  def fetch_expense_category(value)
    ExpenseCategory.find_by(name: value, user: @user) || raise('Categoria não encontrada')
  end

  def expense_group(value)
    raise_if_blank_value(value, 'Grupo de Despesa não pode fica em branco')

    @expense_groups[value] ||= fetch_expense_group(value)
  end

  def fetch_expense_group(value)
    ExpenseGroup.find_by(name: value, user: @user) || raise('Grupo de Despesa não encontrado')
  end

  def place(value)
    raise_if_blank_value(value, 'Local não pode fica em branco')

    @places[value] ||= fetch_place(value)
  end

  def fetch_place(value)
    Place.find_by(name: value, user: @user) || raise('Local não encontrado')
  end

  def fixed(value)
    raise_if_blank_value(value, 'Fixo? não pode fica em branco')

    value.casecmp('sim').zero?
  end

  def raise_if_blank_value(value, message)
    raise(message) if value.blank?
  end
end

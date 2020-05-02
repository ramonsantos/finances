# frozen_string_literal: true

class CreateExpensesFromCsv
  require 'csv'

  EXPENSES_CSV_HEADER = 'Descrição,Valor,Data,Categoria,Grupo de Despesa,Local,Fixo?,Observações'

  def initialize(user, file_path)
    @user = user
    @file_path = file_path
  end

  def create_expenses
    CSV.foreach(file_path, headers: true) do |row|
      expenses_attributes = {
        user: user,
        description: row['Descrição'],
        amount: amount(row['Valor']),
        date: date(row['Data']),
        expense_category_id: category(row['Categoria']),
        place_id: place(row['Local']),
        expense_group_id: expense_group(row['Grupo de Despesa']),
        remark: row['Observações'],
        fixed: fixed(row['Fixo?'])
      }

      Expense.create!(expenses_attributes)
    end
  end

  private

  def build_expense_from_line(csv_line)

  end

  def amount(value)
    value.gsub(/[R$ ]/, '').tr(',', '.').to_f
  end

  def fixed(value)
    value.casecmp('sim').zero?
  end

  def expense_group(value)
    ExpenseGroup.find_by(name: value).id
  end

  def place(value)
    Place.find_by(name: value).id
  end

  def category(value)
    # TODO - Chance Category from enum to model
    'Alimentação'
  end

  def date(value)
    # TODO - implement
    Date.current
  end
end

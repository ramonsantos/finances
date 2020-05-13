class AddExpensesCountToExpenseCategory < ActiveRecord::Migration[6.0]
  def change
    add_column :expense_categories, :expenses_count, :integer, default: 0
  end
end

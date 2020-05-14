class AddExpensesCountToExpenseGroup < ActiveRecord::Migration[6.0]
  def change
    add_column :expense_groups, :expenses_count, :integer, default: 0
  end
end

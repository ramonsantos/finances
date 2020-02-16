class AddExpenseGroupIdToExpenses < ActiveRecord::Migration[6.0]
  def change
    add_reference :expenses, :expense_group, index: true, foreign_key: true
  end
end

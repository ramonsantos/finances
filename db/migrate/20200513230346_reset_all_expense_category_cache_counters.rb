class ResetAllExpenseCategoryCacheCounters < ActiveRecord::Migration[6.0]
  def up
    ExpenseCategory.all.each do |expense_category|
      ExpenseCategory.reset_counters(expense_category.id, :expenses)
    end
  end

  def down
  end
end

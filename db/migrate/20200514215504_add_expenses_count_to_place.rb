class AddExpensesCountToPlace < ActiveRecord::Migration[6.0]
  def change
    add_column :places, :expenses_count, :integer, default: 0
  end
end

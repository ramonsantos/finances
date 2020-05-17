class AlterColumnExpenseGroupsName < ActiveRecord::Migration[6.0]
  def change
    add_index :expense_groups, :name, unique: true
  end
end

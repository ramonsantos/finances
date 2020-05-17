class AlterColumnExpenseCategoriesName < ActiveRecord::Migration[6.0]
  def change
    add_index :expense_categories, :name, unique: true
  end
end

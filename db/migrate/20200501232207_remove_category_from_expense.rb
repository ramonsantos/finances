class RemoveCategoryFromExpense < ActiveRecord::Migration[6.0]
  def change
    remove_column :expenses, :category, :string
  end
end

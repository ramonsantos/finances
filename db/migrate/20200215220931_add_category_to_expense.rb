class AddCategoryToExpense < ActiveRecord::Migration[6.0]
  def change
    add_column :expenses, :category, :string, default: 'food'
  end
end

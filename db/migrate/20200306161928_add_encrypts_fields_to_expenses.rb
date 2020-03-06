class AddEncryptsFieldsToExpenses < ActiveRecord::Migration[6.0]
  def change
    remove_column :expenses, :description
    remove_column :expenses, :amount

    add_column :expenses, :description_ciphertext, :text
    add_column :expenses, :amount_ciphertext, :text
  end
end

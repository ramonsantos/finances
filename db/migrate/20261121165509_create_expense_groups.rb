class CreateExpenseGroups < ActiveRecord::Migration[8.1]
  def change
    create_table :expense_groups do |t|
      t.string :name, null: false
      t.integer :expenses_count, default: 0, null: false

      t.timestamps
    end

    add_index :expense_groups, "lower(name)", unique: true, name: "index_expense_groups_on_lower_name"
  end
end
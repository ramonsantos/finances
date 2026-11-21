class CreateExpenses < ActiveRecord::Migration[8.1]
  def change
    create_table :expenses do |t|
      t.string :description, null: false
      t.decimal :amount, precision: 12, scale: 2, null: false
      t.date :date, null: false
      t.boolean :fixed, default: false, null: false
      t.text :remark
      t.references :expense_category, null: false, foreign_key: { on_delete: :restrict }
      t.references :expense_group, null: false, foreign_key: { on_delete: :restrict }

      t.timestamps
    end

    add_index :expenses, :date
  end
end
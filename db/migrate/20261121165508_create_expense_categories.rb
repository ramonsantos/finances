# frozen_string_literal: true

class CreateExpenseCategories < ActiveRecord::Migration[8.1]
  def change
    create_table(:expense_categories) do |t|
      t.string(:name, null: false)
      t.text(:description)
      t.integer(:expenses_count, default: 0, null: false)

      t.timestamps
    end

    add_index(:expense_categories, 'lower(name)', unique: true, name: 'index_expense_categories_on_lower_name')
  end
end

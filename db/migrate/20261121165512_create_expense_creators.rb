class CreateExpenseCreators < ActiveRecord::Migration[8.1]
  def change
    create_table :expense_creators do |t|
      t.datetime :date, null: false
      t.integer :status, default: 0, null: false
      t.integer :expense_creator_results_count, default: 0, null: false

      t.timestamps
    end
  end
end
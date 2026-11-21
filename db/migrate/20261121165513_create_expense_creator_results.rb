class CreateExpenseCreatorResults < ActiveRecord::Migration[8.1]
  def change
    create_table :expense_creator_results do |t|
      t.references :expense_creator, null: false, foreign_key: { on_delete: :cascade }
      t.text :raw_content, null: false
      t.boolean :success
      t.string :details, null: false

      t.timestamps
    end
  end
end
class CreateExpenseCreatorResults < ActiveRecord::Migration[6.0]
  def change
    create_table :expense_creator_results do |t|
      t.text :raw_content
      t.boolean :success
      t.string :details

      t.timestamps
    end
  end
end

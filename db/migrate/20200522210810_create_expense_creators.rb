class CreateExpenseCreators < ActiveRecord::Migration[6.0]
  def change
    create_table :expense_creators do |t|
      t.datetime :date

      t.timestamps
    end
  end
end

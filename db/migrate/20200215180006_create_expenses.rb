class CreateExpenses < ActiveRecord::Migration[6.0]
  def change
    create_table :expenses do |t|
      t.string :description
      t.float :amount
      t.date :date
      t.boolean :fixed
      t.text :remark

      t.timestamps
    end
  end
end

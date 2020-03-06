class CreateLoans < ActiveRecord::Migration[6.0]
  def change
    create_table :loans do |t|
      t.date :loan_date
      t.date :estimated_receipt_at
      t.date :received_at

      t.timestamps
    end
  end
end

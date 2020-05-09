class RemoveEstimatedReceiptAtFromLoans < ActiveRecord::Migration[6.0]
  def change
    remove_column :loans, :estimated_receipt_at, :date
  end
end

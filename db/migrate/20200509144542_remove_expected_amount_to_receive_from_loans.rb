class RemoveExpectedAmountToReceiveFromLoans < ActiveRecord::Migration[6.0]
  def change
    remove_column :loans, :expected_amount_to_receive_ciphertext, :text
  end
end

class AddEncryptsFieldsToLoans < ActiveRecord::Migration[6.0]
  def change
    add_column :loans, :description_ciphertext,                :text
    add_column :loans, :person_ciphertext,                     :text
    add_column :loans, :borrowed_amount_ciphertext,            :text
    add_column :loans, :expected_amount_to_receive_ciphertext, :text
    add_column :loans, :gain_ciphertext,                       :text
  end
end

# frozen_string_literal: true

class AddDatabaseConsistencyConstraints < ActiveRecord::Migration[8.1]
  def up
    add_check_constraint(:loans, 'borrowed_amount >= 0.01', name: 'loans_borrowed_amount_check')
    add_check_constraint(
      :loans,
      'received_amount IS NULL OR received_amount >= 0.01',
      name: 'loans_received_amount_check'
    )
    add_check_constraint(:expenses, 'amount >= 0.01', name: 'expenses_amount_check')
  end

  def down
    remove_check_constraint(:expenses, name: 'expenses_amount_check')
    remove_check_constraint(:loans, name: 'loans_received_amount_check')
    remove_check_constraint(:loans, name: 'loans_borrowed_amount_check')
  end
end

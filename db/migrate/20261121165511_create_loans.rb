# frozen_string_literal: true

class CreateLoans < ActiveRecord::Migration[8.1]
  def change
    create_table(:loans) do |t|
      t.string(:person, null: false)
      t.string(:description, null: false)
      t.decimal(:borrowed_amount, precision: 12, scale: 2, null: false)
      t.decimal(:received_amount, precision: 12, scale: 2)
      t.date(:loan_date, null: false)
      t.date(:received_at)

      t.timestamps
    end
  end
end

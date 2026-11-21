# frozen_string_literal: true

class CreatePaymentMethods < ActiveRecord::Migration[8.1]
  def change
    create_table(:payment_methods) do |t|
      t.string(:name, null: false)
      t.integer(:expenses_count, default: 0, null: false)

      t.timestamps
    end

    add_index(:payment_methods, 'lower(name)', unique: true, name: 'index_payment_methods_on_lower_name')
  end
end

class AddPlaceIdToExpenses < ActiveRecord::Migration[6.0]
  def change
    add_reference :expenses, :place, index: true, foreign_key: true
  end
end

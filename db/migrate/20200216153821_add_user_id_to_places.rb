class AddUserIdToPlaces < ActiveRecord::Migration[6.0]
  def change
    add_reference :places, :user, index: true, foreign_key: true
  end
end

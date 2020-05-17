class AlterColumnPlacesName < ActiveRecord::Migration[6.0]
  def change
    add_index :places, :name, unique: true
  end
end

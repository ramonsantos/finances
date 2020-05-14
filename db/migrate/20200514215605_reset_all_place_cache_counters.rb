class ResetAllPlaceCacheCounters < ActiveRecord::Migration[6.0]
  def up
    Place.all.each do |place|
      Place.reset_counters(place.id, :expenses)
    end
  end

  def down
  end
end

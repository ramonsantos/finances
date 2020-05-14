class ResetAllExpenseGroupCacheCounters < ActiveRecord::Migration[6.0]
  def up
    ExpenseGroup.all.each do |place|
      ExpenseGroup.reset_counters(place.id, :expenses)
    end
  end

  def down
  end
end

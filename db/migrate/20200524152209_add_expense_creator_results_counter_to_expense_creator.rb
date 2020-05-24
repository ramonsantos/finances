class AddExpenseCreatorResultsCounterToExpenseCreator < ActiveRecord::Migration[6.0]
  def change
    add_column :expense_creators, :expense_creator_results_count, :integer, default: 0
  end
end

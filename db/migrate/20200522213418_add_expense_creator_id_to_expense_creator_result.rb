class AddExpenseCreatorIdToExpenseCreatorResult < ActiveRecord::Migration[6.0]
  def change
    add_reference :expense_creator_results, :expense_creator, index: true, foreign_key: true
  end
end

class AddUserIdToExpenseGroups < ActiveRecord::Migration[6.0]
  def change
    add_reference :expense_groups, :user, index: true, foreign_key: true
  end
end

class AddUserIdToExpenseCreator < ActiveRecord::Migration[6.0]
  def change
    add_reference :expense_creators, :user, index: true, foreign_key: true
  end
end

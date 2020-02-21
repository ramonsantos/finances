# frozen_string_literal: true

module ExpensesHelper
  def only_numbers_script
    "this.value=this.value.replace(/[^0-9.]/g,'');"
  end

  def expense_date(expense)
    (expense.date || Time.zone.today).to_s
  end

  def current_option(expense, attribute_list)
    (expense.place_id || attribute_list.first)
  end
end

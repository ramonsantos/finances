# frozen_string_literal: true

module ExpensesHelper
  def only_numbers_script
    "this.value=this.value.replace(/[^0-9.]/g,'');"
  end
end

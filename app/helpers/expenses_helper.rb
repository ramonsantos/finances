# frozen_string_literal: true

module ExpensesHelper
  def only_numbers_script
    "this.value=this.value.replace(/[^0-9]/g,'');"
  end

  def normalize_amount
    'var expenseAmountElement = document.getElementById("expense_amount");' \
    'expenseAmountElement.value = expenseAmountElement.value.replace(/[R][$][ ]/, "").replace(",", ".")'
  end

  def formated_amount(amount)
    return '' if amount.blank?

    format('R$ %<amount>.2f', amount: amount).tr('.', ',')
  end

  def expense_date(expense)
    (expense.date || Time.zone.today).to_s
  end

  def current_option(expense, attribute_method, attribute_list)
    (expense.try(attribute_method) || attribute_list.first.last)
  end
end

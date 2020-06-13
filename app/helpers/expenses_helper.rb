# frozen_string_literal: true

module ExpensesHelper
  def formated_percent(value)
    value ||= 0.0
    number_with_precision(value.round(2), precision: 2)
  end

  def current_option(expense, attribute_method, attribute_list)
    (expense.try(attribute_method) || attribute_list.first.last)
  end

  def month_label(month, current_expense_month)
    build_month_label(choose_date_by_month(current_expense_month, month))
  end

  def month_param(current_expense_month, month = :current)
    choose_date_by_month(current_expense_month, month).to_s
  end

  def fixed_label(fixed)
    fixed ? :fixed : :not_fixed
  end

  def remark_preview(remark)
    return remark if remark.blank? || remark.length <= 30

    "#{remark.first(27)}..."
  end

  private

  def build_month_label(date)
    "#{t('date.abbr_month_names')[date.month].capitalize}/#{date.year}"
  end

  def choose_date_by_month(current_date, month_sym)
    current_date + { prev: -1, current: 0, next: 1 }[month_sym].month
  end
end

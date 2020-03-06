# frozen_string_literal: true

module ExpensesHelper
  def formated_percent(value)
    number_with_precision((value || 0.0).round(2), precision: 2)
  end

  def current_option(expense, attribute_method, attribute_list)
    (expense.try(attribute_method) || attribute_list.first.last)
  end

  def month_label(month, current_expense_month)
    current_date = current_expense_month

    case month
    when :prev
      build_month_label(current_date - 1.month)
    when :current
      build_month_label(current_date)
    when :next
      build_month_label(current_date + 1.month)
    end
  end

  def month_param(current_expense_month, month = :current)
    current_date = current_expense_month

    case month
    when :prev
      (current_date - 1.month).to_s
    when :current
      current_date.to_s
    when :next
      (current_date + 1.month).to_s
    end
  end

  def fixed_label(fixed)
    fixed ? 'Sim' : 'Não'
  end

  def format_to_money(amount)
    number_to_currency(amount, unit: 'R$', separator: ',', delimiter: '.', format: '%n %u')
  end

  def format_date(date)
    date.strftime('%d/%m/%Y')
  end

  def remark_preview(remark)
    return remark if remark.blank? || remark.length <= 20

    "#{remark.first(17)}..."
  end

  private

  def build_month_label(date)
    "#{(I18n.t :abbr_month_names, scope: :date)[date.month].capitalize}/#{date.year}"
  end
end

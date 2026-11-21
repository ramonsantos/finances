# frozen_string_literal: true

module ApplicationHelper
  BTN_PRIMARY = "inline-flex items-center rounded-lg bg-emerald-600 px-4 py-2 text-sm font-medium text-white shadow-sm hover:bg-emerald-700"
  BTN_PRIMARY_SM = "inline-flex items-center rounded-lg bg-emerald-600 px-3 py-1.5 text-sm font-medium text-white hover:bg-emerald-700"
  BTN_PRIMARY_XS = "inline-flex items-center rounded-lg bg-emerald-600 px-2.5 py-1 text-xs font-medium text-white hover:bg-emerald-700"
  BTN_OUTLINE = "inline-flex items-center rounded-lg border border-slate-300 bg-white px-3 py-1.5 text-sm font-medium text-slate-700 hover:bg-slate-50"
  BTN_DANGER_XS = "inline-flex items-center rounded-lg bg-red-600 px-2.5 py-1 text-xs font-medium text-white hover:bg-red-700"

  def btn_primary = BTN_PRIMARY
  def btn_primary_sm = BTN_PRIMARY_SM
  def btn_primary_xs = BTN_PRIMARY_XS
  def btn_outline = BTN_OUTLINE
  def btn_danger_xs = BTN_DANGER_XS

  def input_class
    "mt-1 block w-full rounded-lg border border-slate-300 px-3 py-2 text-sm shadow-sm focus:border-emerald-500 focus:outline-none focus:ring-1 focus:ring-emerald-500"
  end

  def label_class
    "block text-sm font-medium text-slate-700"
  end

  def current_year
    Time.zone.today.year
  end

  def formatted_money(value)
    return "" if value.blank?

    number_to_currency(value, format: "%u %n")
  end

  def form_amount_value(value)
    return "" if value.blank?

    format("%.2f", value.to_d)
  end

  def expense_month_label(date, offset = :current)
    month_date = date + { prev: -1, current: 0, next: 1 }.fetch(offset).months
    month_name = I18n.t("date.abbr_month_names")[month_date.month]
    "#{month_name.capitalize}/#{month_date.year}"
  end

  def expense_month_param(date, offset = :current)
    month_date = date + { prev: -1, current: 0, next: 1 }.fetch(offset).months
    month_date.to_s
  end

  def parse_expense_month(param)
    return Time.zone.today if param.blank?

    Date.parse(param)
  rescue ArgumentError
    Time.zone.today
  end

  def remark_preview(remark)
    return remark if remark.blank? || remark.length <= 30

    "#{remark.first(27)}..."
  end

  def fixed_badge(fixed)
    key = fixed ? :yes : :no
    t("expenses.fixed.#{key}")
  end

  def loans_title(status)
    t("loans.status.#{status == :received ? :closed : :open}")
  end

  def pagy_nav(pagy)
    return "" if pagy.pages <= 1

    pagy.series_nav(
      id: "pagination",
      aria_label: t("pagination.aria_label"),
      class: "pagy-nav"
    )
  end
end
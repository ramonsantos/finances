# frozen_string_literal: true

module ApplicationHelper
  def only_numbers_script
    "this.value=this.value.replace(/[^0-9]/g,'');"
  end

  def formated_float_value(value)
    return '' if value.blank?

    format('R$ %<value>.2f', value: value).tr('.', ',')
  end

  def date_field(date)
    (date || Time.zone.today).to_s
  end

  def current_year
    Time.zone.today.year.to_s
  end

  def normalize_float_value(element)
    js_var = "#{element.camelize(:lower)}Element"

    "var #{js_var} = document.getElementById(\"#{element}\");#{js_var}.value = #{js_var}.value.replace(/[R][$][ ]/, \"\").replace(\",\", \".\");"
  end

  def normalize_float_values(elements)
    elements.map! { |element| normalize_float_value(element) }.join
  end
end

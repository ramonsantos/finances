# frozen_string_literal: true

module ApplicationHelper
  def current_year
    Time.zone.today.year.to_s
  end

  def only_numbers_script
    "this.value=this.value.replace(/[^0-9]/g,'');"
  end

  def formated_money_value(value)
    return '' if value.blank?

    number_to_currency(value, format: '%u %n')
  end

  def date_field(date, use_current_time_when_date_blank = true)
    choose_date(date, use_current_time_when_date_blank).to_s
  end

  def normalize_float_value(element)
    js_var = "#{element.camelize(:lower)}Element"

    "var #{js_var} = document.getElementById(\"#{element}\");" \
    "#{js_var}.value = #{js_var}.value.replace(/[R][$][ ]/, \"\").replace(\".\", \"\").replace(\",\", \".\");"
  end

  def normalize_float_values(elements)
    elements.map! { |element| normalize_float_value(element) }.join
  end

  def validation_class(fields_validation, field)
    fields_validation.try(:dig, field, :status) == :error ? ' is-invalid' : nil
  end

  private

  def choose_date(date, use_current_time_when_date_blank)
    return date if date.present?
    return Time.zone.today if use_current_time_when_date_blank

    nil
  end
end

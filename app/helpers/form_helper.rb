# frozen_string_literal: true

module FormHelper
  def required_form_label(form, attribute, label: nil)
    text = label || t("activerecord.attributes.#{form.object.model_name.i18n_key}.#{attribute}")

    form.label(attribute, class: label_class) do
      safe_join([text, tag.span(t('label.required'), class: 'text-red-600', aria: { hidden: true })])
    end
  end
end

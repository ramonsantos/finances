# frozen_string_literal: true

module FlashHelper
  TOAST_CONFIG = {
    notice: {
      timeout: 5000,
      role: 'status',
      aria_live: 'polite',
      container_class: 'border-sky-200 bg-sky-50',
      text_class: 'text-sky-800',
      icon: :success
    },
    alert: {
      timeout: 8000,
      role: 'alert',
      aria_live: 'assertive',
      container_class: 'border-red-200 bg-red-50',
      text_class: 'text-red-800',
      icon: :error
    }
  }.freeze

  def flash_toasts
    TOAST_CONFIG.filter_map do |key, config|
      message = flash_toast_message(key)
      next if message.blank?

      config.merge(key: key, message: message)
    end
  end

  private

  def flash_toast_message(key)
    case key
    when :notice then notice
    when :alert then alert
    else flash[key]
    end
  end
end

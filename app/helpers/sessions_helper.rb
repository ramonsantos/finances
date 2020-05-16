# frozen_string_literal: true

module SessionsHelper
  def show_sign_in_error?(alert)
    return false if alert.blank?

    alert != 'translation missing: pt-BR.devise.failure.user.unauthenticated'
  end
end

# frozen_string_literal: true

module I18nBasePath
  extend ActiveSupport::Concern

  private

  def i18n_base_path
    "controllers.#{self.class.to_s.underscore.gsub('_controller', '')}"
  end
end

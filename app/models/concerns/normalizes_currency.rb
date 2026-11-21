# frozen_string_literal: true

module NormalizesCurrency
  extend ActiveSupport::Concern

  class_methods do
    def normalizes_currency(*attributes)
      attributes.each do |attribute|
        normalizes attribute, apply_to_nil: false, with: lambda { |value|
          return value if value.is_a?(Numeric) || value.blank?

          value.to_s.gsub(/[R$\s.]/, "").tr(",", ".").to_d
        }
      end
    end
  end
end
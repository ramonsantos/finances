# frozen_string_literal: true

module FormatName
  extend ActiveSupport::Concern

  private

  def format_name!
    self.name = name.upcase_first
  end
end

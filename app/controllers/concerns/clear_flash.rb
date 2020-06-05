# frozen_string_literal: true

module ClearFlash
  extend ActiveSupport::Concern

  private

  def clear_flash
    flash.clear
  end
end

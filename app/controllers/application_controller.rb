# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pagy::Method

  before_action { Pagy::I18n.locale = I18n.locale.to_s }

  allow_browser versions: :modern
end

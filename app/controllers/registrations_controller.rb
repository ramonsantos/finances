# frozen_string_literal: true

class RegistrationsController < Devise::RegistrationsController
  include I18nBasePath
  include ClearFlash

  after_action :clear_flash, only: :create

  # GET /users/sign_up
  def new
    super
  end

  # POST /users
  def create
    if place_name.present?
      super { build_create_response }
    else
      render_error_response
    end

    flash.clear
  end

  private

  def render_error_response
    build_resource(user_params).validate
    build_create_response(place_error)

    render(:new)
  end

  def build_create_response(place_error = {})
    if create_with_success?(place_error)
      Place.create(name: place_name, user: resource)
    else
      @fields_validation = build_fields_validation(place_error)
    end
  end

  def build_fields_validation(place_error)
    place_error.tap do |hash|
      messages = user.errors.messages

      messages.keys.map do |key|
        hash[key] = build_field_validation(:error, messages[key].first)
      end
    end
  end

  def create_with_success?(place_error)
    user.errors.details.blank? && place_error.blank?
  end

  def place_error
    { name: build_field_validation(:error, t("#{i18n_base_path}.errors.cant_be_blank")) }
  end

  def build_field_validation(status, message)
    { status: status, message: message }
  end

  def user_params
    resource_params.permit(:email, :password, :password_confirmation)
  end

  def user
    resource
  end

  def place_params
    params.require(:user).require(:places).permit(:name)
  rescue StandardError
    nil
  end

  def place_name
    @place_name ||= place_params.try(:fetch, :name)
  end
end

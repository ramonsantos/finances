# frozen_string_literal: true

class RegistrationsController < Devise::RegistrationsController
  # GET /users/sign_up
  def new
    super
  end

  # POST /users
  def create
    if place_name.present?
      super do |user|
        build_create_response(user)
      end
    else
      render_error_response
    end

    flash.clear
  end

  private

  def render_error_response
    build_resource(user_params).validate
    build_create_response(resource, place_error)

    render(:new)
  end

  def build_create_response(user, place_error = {})
    if create_with_success?(user, place_error)
      Place.create(name: place_name, user: resource)
    else
      @fields_validation = build_fields_validation(user, place_error)
    end
  end

  def build_fields_validation(user, place_error)
    place_error.tap do |hash|
      messages = user.errors.messages

      messages.keys.map do |key|
        hash[key] = build_field_validation(:error, messages[key].first)
      end
    end
  end

  def create_with_success?(user, place_error)
    user.errors.details.blank? && place_error.blank?
  end

  def place_error
    { name: build_field_validation(:error, 'não pode ficar vazio') }
  end

  def build_field_validation(status, message)
    { status: status, message: message }
  end

  def user_params
    resource_params.permit(:email, :password, :password_confirmation)
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

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
      place_error = {
        name: {
          status: :error,
          message: 'não pode ficar vazio'
        }
      }

      build_resource(user_params).validate
      build_create_response(resource, place_error)

      render(:new)
    end

    flash.clear
  end

  private

  def build_create_response(user, place_error = {})
    if user.errors.details.blank? && place_error.blank?
      Place.create(name: place_name, user: resource)
    else
      @fields_validation = place_error.tap do |hash|
        messages = user.errors.messages

        messages.keys.map do |key|
          hash[key] = {
            status: :error,
            message: messages[key].first
          }
        end
      end
    end
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

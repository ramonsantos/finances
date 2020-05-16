# frozen_string_literal: true

class RegistrationsController < Devise::RegistrationsController
  # GET /users/sign_up
  def new
    flash[:notice] = nil
    super
  end

  # POST /users
  def create
    if place_name.present?
      super do |user|
        build_create_response(user)
      end
    else
      render(:new)
    end
  end

  private

  def build_create_response(user)
    if user.errors.details.blank?
      Place.create(name: place_name, user: current_user)
      flash.clear
    else
      @fields_validation = {}.tap do |hash|
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

  def place_params
    params.require(:user).require(:places).permit(:name)
  rescue StandardError
    nil
  end

  def place_name
    @place_name ||= place_params.try(:fetch, :name)
  end
end

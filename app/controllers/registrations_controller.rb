# frozen_string_literal: true

class RegistrationsController < Devise::RegistrationsController
  # POST /users
  def create
    if place_name.present?
      super
      Place.create(name: place_name, user: current_user)
      flash.delete(:notice)
    else
      redirect_to(new_user_registration_path)
    end
  end

  private

  def place_params
    params.require(:user).require(:places).permit(:name)
  rescue StandardError
    nil
  end

  def place_name
    @place_name ||= place_params.try(:fetch, :name)
  end
end

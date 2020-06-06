# frozen_string_literal: true

class PlacesController < ApplicationController
  include I18nBasePath
  include CreateAction
  include DestroyAction

  before_action :place, only: [:destroy]

  # GET /places
  def index
    @places = current_user.places.order(:name)
    @place  = Place.new
  end

  # POST /places
  def create
    @place = Place.new(place_params)

    create_action(@place, places_path, :index)
  end

  # DELETE /places/1
  def destroy
    destroy_action(@place, places_path)
  end

  private

  def place_params
    params.require(:place).permit(:name).merge!(user: current_user)
  end

  def place
    @place ||= current_user.places.find(params[:id])
  end
end

# frozen_string_literal: true

class PlacesController < ApplicationController
  include CreateAction
  include DestroyAction

  before_action :place, only: [:destroy]

  # GET /places
  def index
    @places = Place.where(user: current_user)
    @place  = Place.new
  end

  # POST /places
  def create
    @place = Place.new(place_params.merge!(user: current_user))

    create_action(@place, places_path, 'Local adicionado.', :index)
  end

  # DELETE /places/1
  def destroy
    redirect_to(places_path, try_destroy(@place, destroy_messages))
  end

  private

  def place_params
    params.require(:place).permit(:name)
  end

  def place
    @place ||= fetch_place
  end

  def fetch_place
    Place.find_by(id: params[:id], user: current_user)
  end

  def destroy_messages
    {
      success: 'Local removido.',
      error: 'Ocorreu um erro ao remover o local.'
    }
  end
end

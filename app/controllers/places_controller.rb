# frozen_string_literal: true

class PlacesController < ApplicationController
  include CreateAction

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
    redirect_to(places_path, try_destroy)
  end

  private

  def place_params
    params.require(:place).permit(:name)
  end

  def fetch_place
    Place.find(params[:id])
  end

  def try_destroy
    fetch_place.destroy
    { notice: 'Local removido.' }
  rescue StandardError
    { alert: 'Ocorreu um erro ao remover o local.' }
  end
end

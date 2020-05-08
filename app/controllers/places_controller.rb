# frozen_string_literal: true

class PlacesController < ApplicationController
  # GET /places
  def index
    @places = Place.where(user: current_user)
    @place  = Place.new
  end

  # POST /places
  def create
    @place = Place.new(place_params.merge!(user: current_user))

    if @place.save
      redirect_to(places_path, notice: 'Local adicionado.')
    else
      render(:index)
    end
  end

  # DELETE /places/1
  def destroy
    if destroy_place
      redirect_to(places_path, notice: 'Local removido.')
    else
      redirect_to(places_path, notice: 'Ocorreu um erro ao remover o local.')
    end
  end

  private

  def place_params
    params.require(:place).permit(:name)
  end

  def fetch_place
    Place.find(params[:id])
  end

  def destroy_place
    fetch_place.destroy
    true
  rescue StandardError
    false
  end
end

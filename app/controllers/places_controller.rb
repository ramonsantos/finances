# frozen_string_literal: true

class PlacesController < ApplicationController
  # GET /places
  # GET /places.json
  def index
    @places = Place.where(user: current_user)
    @place  = Place.new
  end

  # POST /places
  # POST /places.json
  def create
    @place = Place.new(place_params.merge!(user: current_user))

    respond_to do |format|
      if @place.save
        format.html { redirect_to places_path, notice: 'Local adicionado.' }
        format.json { render :index, status: :created }
      else
        format.html { render :index }
        format.json { render json: @place.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /places/1
  # DELETE /places/1.json
  def destroy
    respond_to do |format|
      if destroy_place
        format.html { redirect_to places_path, notice: 'Local removido.' }
        format.json { render :index, status: :created }
      else
        format.html { redirect_to places_path, notice: 'Ocorreu um erro ao remover o local.' }
        format.json { render json: { error: 'Ocorreu um erro ao remover o local.' }, status: :unprocessable_entity }
      end
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
  rescue
    false
  end
end

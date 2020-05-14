# frozen_string_literal: true

require 'rails_helper'

describe PlacesController, type: :controller do
  login_user

  let!(:place) { create(:place) }

  let(:valid_attributes) do
    attributes_for(:place)
  end

  let(:invalid_attributes) do
    attributes_for(:place, name: nil)
  end

  describe 'GET #index' do
    it 'returns a success response' do
      get(:index)
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Place' do
        expect do
          post(:create, params: { place: valid_attributes })
        end.to change(Place, :count).by(1)
      end

      it 'shows flash notice' do
        post(:create, params: { place: valid_attributes })
        expect(flash[:notice]).to eq('Local adicionado.')
      end

      it 'redirects to the created Place' do
        post(:create, params: { place: valid_attributes })
        expect(response).to redirect_to(places_path)
      end
    end

    context 'with invalid params' do
      it 'does not creates a new Place' do
        expect do
          post(:create, params: { place: invalid_attributes })
        end.not_to change(Place, :count)
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:params) { { id: place.id } }

    it 'destroys the requested place' do
      expect do
        delete(:destroy, params: params)
      end.to change(Place, :count).by(-1)
    end

    it 'shows flash notice' do
      delete(:destroy, params: params)
      expect(flash[:notice]).to eq('Local removido.')
    end

    it 'redirects to the places list' do
      delete(:destroy, params: params)
      expect(response).to redirect_to(places_path)
    end

    context 'when Place has a Expense' do
      before do
        create(:expense, place_id: place.id)
      end

      it 'destroys the requested place' do
        expect do
          delete(:destroy, params: params)
        end.not_to change(Place, :count)
      end

      it 'shows flash notice' do
        delete(:destroy, params: params)
        expect(flash[:alert]).to eq('Ocorreu um erro ao remover o local.')
      end

      it 'redirects to the places list' do
        delete(:destroy, params: params)
        expect(response).to redirect_to(places_path)
      end
    end
  end
end

require 'rails_helper'

RSpec.describe PlacesController, type: :controller do
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # PlacesController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET #index" do
    it "returns a success response" do
      Place.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "GET #new" do
    it "returns a success response" do
      get :new, params: {}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Place" do
        expect {
          post :create, params: {place: valid_attributes}, session: valid_session
        }.to change(Place, :count).by(1)
      end

      it "redirects to the created place" do
        post :create, params: {place: valid_attributes}, session: valid_session
        expect(response).to redirect_to(Place.last)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: {place: invalid_attributes}, session: valid_session
        expect(response).to be_successful
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested place" do
      place = Place.create! valid_attributes
      expect {
        delete :destroy, params: {id: place.to_param}, session: valid_session
      }.to change(Place, :count).by(-1)
    end

    it "redirects to the places list" do
      place = Place.create! valid_attributes
      delete :destroy, params: {id: place.to_param}, session: valid_session
      expect(response).to redirect_to(places_url)
    end
  end
end

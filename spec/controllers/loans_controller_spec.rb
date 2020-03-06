# frozen_string_literal: true

require 'rails_helper'

describe LoansController, type: :controller do
  let(:valid_attributes) do
    skip('Add a hash of attributes valid for your model')
  end

  let(:invalid_attributes) do
    skip('Add a hash of attributes invalid for your model')
  end

  let(:valid_session) { {} }

  describe 'GET #index' do
    it 'returns a success response' do
      Loan.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      loan = Loan.create! valid_attributes
      get :show, params: { id: loan.to_param }, session: valid_session
      expect(response).to be_successful
    end
  end

  describe 'GET #new' do
    xit 'returns a success response' do
      get :new, params: {}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Loan' do
        expect do
          post :create, params: { loan: valid_attributes }, session: valid_session
        end.to change(Loan, :count).by(1)
      end

      it 'redirects to the created loan' do
        post :create, params: { loan: valid_attributes }, session: valid_session
        expect(response).to redirect_to(Loan.last)
      end
    end

    context 'with invalid params' do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: { loan: invalid_attributes }, session: valid_session
        expect(response).to be_successful
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        skip('Add a hash of attributes valid for your model')
      end

      it 'updates the requested loan' do
        loan = Loan.create! valid_attributes
        put :update, params: { id: loan.to_param, loan: new_attributes }, session: valid_session
        loan.reload
        skip('Add assertions for updated state')
      end

      it 'redirects to the loan' do
        loan = Loan.create! valid_attributes
        put :update, params: { id: loan.to_param, loan: valid_attributes }, session: valid_session
        expect(response).to redirect_to(loan)
      end
    end

    context 'with invalid params' do
      it "returns a success response (i.e. to display the 'edit' template)" do
        loan = Loan.create! valid_attributes
        put :update, params: { id: loan.to_param, loan: invalid_attributes }, session: valid_session
        expect(response).to be_successful
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested loan' do
      loan = Loan.create! valid_attributes
      expect do
        delete :destroy, params: { id: loan.to_param }, session: valid_session
      end.to change(Loan, :count).by(-1)
    end

    it 'redirects to the loans list' do
      loan = Loan.create! valid_attributes
      delete :destroy, params: { id: loan.to_param }, session: valid_session
      expect(response).to redirect_to(loans_url)
    end
  end
end

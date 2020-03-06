# frozen_string_literal: true

require 'rails_helper'

describe LoansController, type: :controller do
  login_user

  let(:valid_attributes) { attributes_for(:loan) }

  let(:invalid_attributes) { attributes_for(:loan, description: nil) }

  describe 'GET #index' do
    xit 'returns a success response' do
      Loan.create! valid_attributes
      get :index, params: {}
      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    xit 'returns a success response' do
      loan = Loan.create! valid_attributes
      get :show, params: { id: loan.to_param }
      expect(response).to be_successful
    end
  end

  describe 'GET #new' do
    it 'returns a success response' do
      get(:new)
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Loan' do
        expect do
          post(:create, params: { loan: valid_attributes })
        end.to change(Loan, :count).by(1)
      end

      it 'shows flash notice' do
        post(:create, params: { loan: valid_attributes })
        expect(flash[:notice]).to eq('Empréstimo adicionado.')
      end

      it 'redirects to the created loan' do
        post(:create, params: { loan: valid_attributes })
        expect(response).to redirect_to(loans_path)
      end
    end

    context 'with invalid params' do
      it "returns a success response (i.e. to display the 'new' template)" do
        post(:create, params: { loan: invalid_attributes })
        expect(response).to be_successful
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        skip('Add a hash of attributes valid for your model')
      end

      xit 'updates the requested loan' do
        loan = Loan.create! valid_attributes
        put :update, params: { id: loan.to_param, loan: new_attributes }
        loan.reload
        skip('Add assertions for updated state')
      end

      xit 'redirects to the loan' do
        loan = Loan.create! valid_attributes
        put :update, params: { id: loan.to_param, loan: valid_attributes }
        expect(response).to redirect_to(loan)
      end
    end

    context 'with invalid params' do
      xit "returns a success response (i.e. to display the 'edit' template)" do
        loan = Loan.create! valid_attributes
        put :update, params: { id: loan.to_param, loan: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe 'DELETE #destroy' do
    xit 'destroys the requested loan' do
      loan = Loan.create! valid_attributes
      expect do
        delete :destroy, params: { id: loan.to_param }
      end.to change(Loan, :count).by(-1)
    end

    xit 'redirects to the loans list' do
      loan = Loan.create! valid_attributes
      delete :destroy, params: { id: loan.to_param }
      expect(response).to redirect_to(loans_url)
    end
  end
end

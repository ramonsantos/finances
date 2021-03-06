# frozen_string_literal: true

require 'rails_helper'

describe LoansController, type: :controller do
  login_user

  let!(:loan) { create(:loan) }

  let(:valid_attributes) { attributes_for(:loan) }

  let(:invalid_attributes) { attributes_for(:loan, description: nil) }

  describe 'GET #index' do
    it 'returns a success response' do
      get(:index, params: {})
      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      get(:show, params: { id: loan.to_param })
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
      it 'does not creates a new Loan' do
        expect do
          post(:create, params: { loan: invalid_attributes })
          expect(response).to be_successful
        end.not_to change(Loan, :count)
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) { { description: 'Pagar Luz', received_amount: 110.42 } }

      before do
        Timecop.freeze(2020, 5, 16)

        put(:update, params: { id: loan.to_param, loan: new_attributes })
      end

      after { Timecop.return }

      it 'updates the requested loan' do
        loan.reload
        expect(loan.description).to eq('Pagar Luz')
        expect(loan.received_amount).to eq(110.42)
        expect(loan.received_at).to eq(Date.parse('May 16 2020'))
      end

      it 'shows flash notice' do
        expect(flash[:notice]).to eq('Empréstimo atualizado.')
      end

      it 'redirects to the loans' do
        expect(response).to redirect_to(loans_path)
      end

      context 'when receives loan' do
        let(:new_attributes) { { received_amount: 110.42, received_at: '2020-05-21' } }

        before { put(:update, params: { id: loan.to_param, loan: new_attributes }) }

        it 'updates the requested loan' do
          loan.reload
          expect(loan.received_amount).to eq(110.42)
          expect(loan.received_at).to eq(Date.parse('May 21 2020'))
        end
      end
    end

    context 'with invalid params' do
      it 'does not updates the Loan' do
        expect do
          put(:update, params: { id: loan.to_param, loan: invalid_attributes })
        end.not_to change(Loan, :first)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested loan' do
      expect do
        delete(:destroy, params: { id: loan.to_param })
      end.to change(Loan, :count).by(-1)
    end

    it 'shows flash notice' do
      delete(:destroy, params: { id: loan.to_param })
      expect(flash[:notice]).to eq('Empréstimo removido.')
    end

    it 'redirects to the loans list' do
      delete(:destroy, params: { id: loan.to_param })
      expect(response).to redirect_to(loans_path)
    end
  end
end

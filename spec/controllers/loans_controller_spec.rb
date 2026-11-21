# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LoansController, type: :controller do
  routes { Rails.application.routes }

  let!(:loan) { create(:loan) }

  let(:valid_attributes) { attributes_for(:loan) }
  let(:invalid_attributes) { attributes_for(:loan, description: nil) }

  describe 'GET #index' do
    it 'returns success for open loans' do
      get(:index)
      expect(response).to have_http_status(:ok)
    end

    it 'returns success for received loans' do
      get(:index, params: { loan_status: :received })
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET #show' do
    it 'returns success' do
      get(:show, params: { id: loan.id })
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET #new' do
    it 'returns success' do
      get(:new)
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a loan' do
        expect do
          post(:create, params: { loan: valid_attributes })
        end.to change(Loan, :count).by(1)
      end

      it 'redirects with a notice' do
        post(:create, params: { loan: valid_attributes })

        expect(response).to redirect_to(loans_path)
        expect(flash[:notice]).to eq('Empréstimo adicionado.')
      end
    end

    context 'with invalid params' do
      it 'does not create a loan' do
        expect do
          post(:create, params: { loan: invalid_attributes })
        end.not_to change(Loan, :count)
      end

      it 'renders new with errors' do
        post(:create, params: { loan: invalid_attributes })

        expect(response).to have_http_status(:unprocessable_content)
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'PATCH #update' do
    let(:new_attributes) { { description: 'Quitado', received_amount: 100.0 } }

    it 'updates the loan' do
      Timecop.freeze(Date.new(2025, 5, 16)) do
        patch(:update, params: { id: loan.id, loan: new_attributes })

        loan.reload
        expect(loan.description).to eq('Quitado')
        expect(loan.received_amount).to eq(100.0)
        expect(loan.received_at).to eq(Date.new(2025, 5, 16))
      end
    end

    it 'redirects with a notice' do
      patch(:update, params: { id: loan.id, loan: { description: 'Outro' } })

      expect(response).to redirect_to(loan_path(loan))
      expect(flash[:notice]).to eq('Empréstimo atualizado.')
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the loan' do
      expect do
        delete(:destroy, params: { id: loan.id })
      end.to change(Loan, :count).by(-1)
    end

    it 'redirects with a notice' do
      delete(:destroy, params: { id: loan.id })

      expect(response).to redirect_to(loans_path(loan_status: :to_receive))
      expect(flash[:notice]).to eq('Empréstimo removido.')
    end
  end
end

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PaymentMethodsController, type: :controller do
  routes { Rails.application.routes }

  let!(:payment_method) { create(:payment_method) }

  let(:valid_attributes) { attributes_for(:payment_method) }
  let(:invalid_attributes) { attributes_for(:payment_method, name: nil) }

  describe 'GET #index' do
    it 'returns success' do
      get(:index)
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a payment method' do
        expect do
          post(:create, params: { payment_method: valid_attributes })
        end.to change(PaymentMethod, :count).by(1)
      end
    end

    context 'with invalid params' do
      it 'does not create a payment method' do
        expect do
          post(:create, params: { payment_method: invalid_attributes })
        end.not_to change(PaymentMethod, :count)
      end

      it 're-renders the index with the modal open' do
        post(:create, params: { payment_method: invalid_attributes })

        expect(response).to have_http_status(:unprocessable_content)
        expect(response).to render_template(:index)
        expect(assigns(:open_payment_method_modal)).to be(true)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when payment method has dependent expenses' do
      let!(:category) { create(:expense_category) }

      before do
        create(:expense, payment_method: payment_method, expense_category: category)
      end

      it 'does not destroy and sets alert' do
        expect do
          delete(:destroy, params: { id: payment_method.id })
        end.not_to change(PaymentMethod, :count)

        expect(response).to redirect_to(payment_methods_path)
        expect(flash[:alert]).to eq('Não é possível excluir uma forma de pagamento com despesas vinculadas.')
      end
    end
  end
end

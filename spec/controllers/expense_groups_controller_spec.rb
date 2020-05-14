# frozen_string_literal: true

require 'rails_helper'

describe ExpenseGroupsController, type: :controller do
  login_user

  let!(:expense_group) { create(:expense_group) }

  let(:valid_attributes) do
    attributes_for(:expense_group)
  end

  let(:invalid_attributes) do
    attributes_for(:expense_group, name: nil)
  end

  describe 'GET #index' do
    it 'returns a success response' do
      get(:index)
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Expense Group' do
        expect do
          post(:create, params: { expense_group: valid_attributes })
        end.to change(ExpenseGroup, :count).by(1)
      end

      it 'shows flash notice' do
        post(:create, params: { expense_group: valid_attributes })
        expect(flash[:notice]).to eq('Grupo de Despesas adicionado.')
      end

      it 'redirects to the created Expense Group' do
        post(:create, params: { expense_group: valid_attributes })
        expect(response).to redirect_to(expense_groups_path)
      end
    end

    context 'with invalid params' do
      it 'does not creates a new Expense Group' do
        expect do
          post(:create, params: { expense_group: invalid_attributes })
        end.not_to change(ExpenseGroup, :count)
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:params) { { id: expense_group.id } }

    it 'destroys the requested expense_group' do
      expect do
        delete(:destroy, params: params)
      end.to change(ExpenseGroup, :count).by(-1)
    end

    it 'shows flash notice' do
      delete(:destroy, params: params)
      expect(flash[:notice]).to eq('Grupo de Despesas removido.')
    end

    it 'redirects to the Expense Groups list' do
      delete(:destroy, params: params)
      expect(response).to redirect_to(expense_groups_path)
    end

    context 'when Expense Group has a Expense' do
      before do
        create(:expense, expense_group_id: expense_group.id)
      end

      it 'destroys the requested Expense Group' do
        expect do
          delete(:destroy, params: params)
        end.not_to change(ExpenseGroup, :count)
      end

      it 'shows flash notice' do
        delete(:destroy, params: params)
        expect(flash[:alert]).to eq('Ocorreu um erro ao remover o grupo de despesas.')
      end

      it 'redirects to the Expense Groups list' do
        delete(:destroy, params: params)
        expect(response).to redirect_to(expense_groups_path)
      end
    end
  end
end

# frozen_string_literal: true

require 'rails_helper'

describe ExpenseCategoriesController, type: :controller do
  login_user

  let!(:expense_category) { create(:expense_category) }

  let(:valid_attributes) { attributes_for(:expense_category) }

  let(:invalid_attributes) { attributes_for(:expense_category, name: nil) }

  describe 'GET #index' do
    it 'returns a success response' do
      get(:index)
      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      get(:show, params: { id: expense_category.to_param })
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
      it 'creates a new ExpenseCategory' do
        expect do
          post(:create, params: { expense_category: valid_attributes })
        end.to change(ExpenseCategory, :count).by(1)
      end

      it 'shows flash notice' do
        post(:create, params: { expense_category: valid_attributes })
        expect(flash[:notice]).to eq('Categoria de Despesa adicionada.')
      end

      it 'redirects to the created expense_category' do
        post(:create, params: { expense_category: valid_attributes })
        expect(response).to redirect_to(expense_categories_path)
      end
    end

    context 'with invalid params' do
      it 'does not creates a new Expense Category' do
        expect do
          post(:create, params: { expense_category: invalid_attributes })
          expect(response).to be_successful
        end.not_to change(ExpenseCategory, :count)
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) { { description: 'Descrição' } }

      before { put(:update, params: { id: expense_category.to_param, expense_category: new_attributes }) }

      it 'updates the requested expense_category' do
        expense_category.reload
        expect(expense_category.description).to eq('Descrição')
      end

      it 'shows flash notice' do
        expect(flash[:notice]).to eq('Categoria de Despesa atualizada.')
      end

      it 'redirects to the expense_category' do
        expect(response).to redirect_to(expense_categories_path)
      end
    end

    context 'with invalid params' do
      it 'does not updates the Expense Category' do
        expect do
          put(:update, params: { id: expense_category.to_param, expense_category: invalid_attributes })
          expect(response).to be_successful
        end.not_to change(ExpenseCategory, :first)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when success' do
      it 'destroys the requested expense_category' do
        expect do
          delete(:destroy, params: { id: expense_category.to_param })
        end.to change(ExpenseCategory, :count).by(-1)
      end

      it 'shows flash notice' do
        delete(:destroy, params: { id: expense_category.to_param })
        expect(flash[:notice]).to eq('Categoria de Despesa removida.')
      end

      it 'redirects to the expense_categories list' do
        delete(:destroy, params: { id: expense_category.to_param })
        expect(response).to redirect_to(expense_categories_url)
      end
    end

    context 'when error' do
      before { create(:expense, expense_category_id: expense_category.id) }

      it 'does not destroy the Expense Category' do
        expect do
          delete(:destroy, params: { id: expense_category.to_param })
        end.not_to change(ExpenseCategory, :count)

        expect(response).to redirect_to(expense_categories_url)
        expect(flash[:alert]).to eq('Error ao remover Categoria de Despesa.')
      end
    end
  end
end

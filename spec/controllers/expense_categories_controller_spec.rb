# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExpenseCategoriesController, type: :controller do
  routes { Rails.application.routes }

  let!(:expense_category) { create(:expense_category) }

  let(:valid_attributes) { attributes_for(:expense_category) }
  let(:invalid_attributes) { attributes_for(:expense_category, name: nil) }

  describe 'GET #index' do
    it 'returns success' do
      get(:index)
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET #show' do
    it 'returns success' do
      get(:show, params: { id: expense_category.id })
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
      it 'creates a category' do
        expect do
          post(:create, params: { expense_category: valid_attributes })
        end.to change(ExpenseCategory, :count).by(1)
      end

      it 'redirects with a notice' do
        post(:create, params: { expense_category: valid_attributes })

        expect(response).to redirect_to(expense_categories_path)
        expect(flash[:notice]).to eq(I18n.t('expense_categories.create.created'))
      end
    end

    context 'with invalid params' do
      it 'renders new' do
        post(:create, params: { expense_category: invalid_attributes })

        expect(response).to have_http_status(:unprocessable_content)
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'PATCH #update' do
    it 'updates the category' do
      patch(:update, params: { id: expense_category.id, expense_category: { name: 'Nova' } })

      expect(expense_category.reload.name).to eq('Nova')
    end

    it 'redirects with a notice' do
      patch(:update, params: { id: expense_category.id, expense_category: { name: 'Nova' } })

      expect(response).to redirect_to(expense_categories_path)
      expect(flash[:notice]).to eq(I18n.t('expense_categories.update.updated'))
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys a category without expenses' do
      expect do
        delete(:destroy, params: { id: expense_category.id })
      end.to change(ExpenseCategory, :count).by(-1)
    end

    it 'blocks destroy when expenses exist' do
      group = create(:expense_group)
      create(:expense, expense_category: expense_category, expense_group: group)

      expect do
        delete(:destroy, params: { id: expense_category.id })
      end.not_to change(ExpenseCategory, :count)

      expect(response).to redirect_to(expense_categories_path)
      expect(flash[:alert]).to eq(I18n.t('expense_categories.destroy.destroy_failed'))
    end
  end
end

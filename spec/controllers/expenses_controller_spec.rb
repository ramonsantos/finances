# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExpensesController, type: :controller do
  routes { Rails.application.routes }

  let!(:category) { create(:expense_category) }
  let!(:group) { create(:expense_group) }
  let!(:expense) { create(:expense, expense_category: category, expense_group: group, date: Time.zone.today) }

  let(:valid_attributes) do
    attributes_for(:expense, expense_category_id: category.id, expense_group_id: group.id)
  end

  let(:invalid_attributes) { attributes_for(:expense, description: nil) }

  describe 'GET #index' do
    it 'returns success' do
      get(:index)
      expect(response).to have_http_status(:ok)
    end

    it 'filters by the given month' do
      create(:expense, date: 2.months.ago, expense_category: category, expense_group: group)

      get(:index, params: { expense_month: Time.zone.today.to_s })

      expect(assigns(:expenses)).to contain_exactly(expense)
    end
  end

  describe 'GET #report' do
    it 'returns success' do
      get(:report)
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET #show' do
    it 'returns success' do
      get(:show, params: { id: expense.id, expense_month: Time.zone.today.to_s })
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
      it 'creates an expense' do
        expect do
          post(:create, params: { expense: valid_attributes })
        end.to change(Expense, :count).by(1)
      end

      it 'redirects with a notice' do
        post(:create, params: { expense: valid_attributes })

        expect(response).to redirect_to(expenses_path(expense_month: Time.zone.today.to_s))
        expect(flash[:notice]).to eq(I18n.t('expenses.create.created'))
      end
    end

    context 'with invalid params' do
      it 'does not create an expense' do
        expect do
          post(:create, params: { expense: invalid_attributes })
        end.not_to change(Expense, :count)
      end

      it 'renders new' do
        post(:create, params: { expense: invalid_attributes })

        expect(response).to have_http_status(:unprocessable_content)
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'PATCH #update' do
    let(:new_attributes) { { description: 'Atualizado' } }

    it 'updates the expense' do
      patch(:update, params: { id: expense.id, expense: new_attributes, expense_month: expense.date.to_s })

      expect(expense.reload.description).to eq('Atualizado')
    end

    it 'redirects with a notice' do
      patch(:update, params: { id: expense.id, expense: new_attributes, expense_month: expense.date.to_s })

      expect(response).to redirect_to(expense_path(expense, expense_month: expense.date.to_s))
      expect(flash[:notice]).to eq(I18n.t('expenses.update.updated'))
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the expense' do
      expect do
        delete(:destroy, params: { id: expense.id, expense_month: expense.date.to_s })
      end.to change(Expense, :count).by(-1)
    end

    it 'redirects back to the month' do
      delete(:destroy, params: { id: expense.id, expense_month: expense.date.to_s })

      expect(response).to redirect_to(expenses_path(expense_month: expense.date.to_s))
      expect(flash[:notice]).to eq(I18n.t('expenses.destroy.destroyed'))
    end
  end
end

# frozen_string_literal: true

require 'rails_helper'

describe ExpensesController, type: :controller do
  login_user

  let(:valid_attributes) do
    attributes_for(:expense)
  end

  let(:invalid_attributes) do
    attributes_for(:expense, description: nil)
  end

  describe 'GET #index' do
    xit 'returns a success response' do
      Expense.create! valid_attributes
      get :index, params: {}
      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    xit 'returns a success response' do
      expense = Expense.create! valid_attributes
      get :show, params: { id: expense.to_param }
      expect(response).to be_successful
    end
  end

  describe 'GET #new' do
    it 'returns a success response' do
      get(:new)
      expect(response).to be_successful
    end
  end

  describe 'GET #edit' do
    xit 'returns a success response' do
      expense = Expense.create! valid_attributes
      get :edit, params: { id: expense.to_param }
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Expense' do
        expect do
          post(:create, params: { expense: valid_attributes })
        end.to change(Expense, :count).by(1)
      end

      it 'shows flash notice' do
        post(:create, params: { expense: valid_attributes })
        expect(flash[:notice]).to eq('Despesa adicionada.')
      end

      it 'redirects to the created expense' do
        post(:create, params: { expense: valid_attributes })
        expect(response).to redirect_to(expenses_path)
      end
    end

    context 'with invalid params' do
      it 'does not creates a new Expense' do
        expect do
          post(:create, params: { expense: invalid_attributes })
        end.not_to change(Expense, :count)
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        skip('Add a hash of attributes valid for your model')
      end

      xit 'updates the requested expense' do
        expense = Expense.create! valid_attributes
        put :update, params: { id: expense.to_param, expense: new_attributes }
        expense.reload
        skip('Add assertions for updated state')
      end

      xit 'redirects to the expense' do
        expense = Expense.create! valid_attributes
        put :update, params: { id: expense.to_param, expense: valid_attributes }
        expect(response).to redirect_to(expense)
      end
    end

    context 'with invalid params' do
      xit "returns a success response (i.e. to display the 'edit' template)" do
        expense = Expense.create! valid_attributes
        put :update, params: { id: expense.to_param, expense: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe 'DELETE #destroy' do
    xit 'destroys the requested expense' do
      expense = Expense.create! valid_attributes
      expect do
        delete :destroy, params: { id: expense.to_param }
      end.to change(Expense, :count).by(-1)
    end

    xit 'redirects to the expenses list' do
      expense = Expense.create! valid_attributes
      delete :destroy, params: { id: expense.to_param }
      expect(response).to redirect_to(expenses_url)
    end
  end
end

# frozen_string_literal: true

require 'rails_helper'

describe ExpensesController, type: :controller do
  login_user

  let(:valid_attributes) do
    skip('Add a hash of attributes valid for your model')
  end

  let(:invalid_attributes) do
    skip('Add a hash of attributes invalid for your model')
  end

  let(:valid_session) { {} }

  describe 'GET #index' do
    it 'returns a success response' do
      Expense.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      expense = Expense.create! valid_attributes
      get :show, params: { id: expense.to_param }, session: valid_session
      expect(response).to be_successful
    end
  end

  describe 'GET #new' do
    it 'returns a success response' do
      get :new, params: {}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe 'GET #edit' do
    it 'returns a success response' do
      expense = Expense.create! valid_attributes
      get :edit, params: { id: expense.to_param }, session: valid_session
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Expense' do
        expect do
          post :create, params: { expense: valid_attributes }, session: valid_session
        end.to change(Expense, :count).by(1)
      end

      it 'redirects to the created expense' do
        post :create, params: { expense: valid_attributes }, session: valid_session
        expect(response).to redirect_to(Expense.last)
      end
    end

    context 'with invalid params' do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: { expense: invalid_attributes }, session: valid_session
        expect(response).to be_successful
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        skip('Add a hash of attributes valid for your model')
      end

      it 'updates the requested expense' do
        expense = Expense.create! valid_attributes
        put :update, params: { id: expense.to_param, expense: new_attributes }, session: valid_session
        expense.reload
        skip('Add assertions for updated state')
      end

      it 'redirects to the expense' do
        expense = Expense.create! valid_attributes
        put :update, params: { id: expense.to_param, expense: valid_attributes }, session: valid_session
        expect(response).to redirect_to(expense)
      end
    end

    context 'with invalid params' do
      it "returns a success response (i.e. to display the 'edit' template)" do
        expense = Expense.create! valid_attributes
        put :update, params: { id: expense.to_param, expense: invalid_attributes }, session: valid_session
        expect(response).to be_successful
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested expense' do
      expense = Expense.create! valid_attributes
      expect do
        delete :destroy, params: { id: expense.to_param }, session: valid_session
      end.to change(Expense, :count).by(-1)
    end

    it 'redirects to the expenses list' do
      expense = Expense.create! valid_attributes
      delete :destroy, params: { id: expense.to_param }, session: valid_session
      expect(response).to redirect_to(expenses_url)
    end
  end
end

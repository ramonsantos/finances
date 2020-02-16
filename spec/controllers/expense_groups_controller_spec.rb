# frozen_string_literal: true

require 'rails_helper'

describe ExpenseGroupsController, type: :controller do
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
      ExpenseGroup.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe 'GET #new' do
    it 'returns a success response' do
      get :new, params: {}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new ExpenseGroup' do
        expect do
          post :create, params: { expense_group: valid_attributes }, session: valid_session
        end.to change(ExpenseGroup, :count).by(1)
      end

      it 'redirects to the created expense_group' do
        post :create, params: { expense_group: valid_attributes }, session: valid_session
        expect(response).to redirect_to(ExpenseGroup.last)
      end
    end

    context 'with invalid params' do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: { expense_group: invalid_attributes }, session: valid_session
        expect(response).to be_successful
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested expense_group' do
      expense_group = ExpenseGroup.create! valid_attributes
      expect do
        delete :destroy, params: { id: expense_group.to_param }, session: valid_session
      end.to change(ExpenseGroup, :count).by(-1)
    end

    it 'redirects to the expense_groups list' do
      expense_group = ExpenseGroup.create! valid_attributes
      delete :destroy, params: { id: expense_group.to_param }, session: valid_session
      expect(response).to redirect_to(expense_groups_url)
    end
  end
end

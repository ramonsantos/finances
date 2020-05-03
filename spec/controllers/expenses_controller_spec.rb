# frozen_string_literal: true

require 'rails_helper'

describe ExpensesController, type: :controller do
  login_user

  let!(:expense) { create(:expense) }

  let!(:expense_other_month) { create(:expense_other_month) }

  let(:valid_attributes) do
    attributes_for(:expense)
  end

  let(:invalid_attributes) do
    attributes_for(:expense, description: nil)
  end

  describe 'GET #index' do
    it 'returns a success response' do
      get(:index)
      expect(response).to be_successful
    end

    context 'when user is not authorized' do
      before do
        sign_out(User.last)
        get(:index)
      end

      it 'returns a redirect response' do
        expect(response).to have_http_status(:found)
      end

      it 'redirects to login page' do
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'GET #report' do
    it 'returns a success response' do
      get(:report)
      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      get(:show, params: { id: expense.to_param })
      expect(response).to be_successful
    end
  end

  describe 'GET #new' do
    it 'returns a success response' do
      get(:new)
      expect(response).to be_successful
    end
  end

  describe 'GET #new_from_csv' do
    it 'returns a success response' do
      get(:new_from_csv)
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

  describe 'POST #create_from_csv' do
    context 'with valid params' do
      let(:file) { fixture_file_upload('spec/fixtures/expenses.csv') }

      it 'creates a new Expense' do
        expect do
          post(:create_from_csv, params: { file: file })
        end.to change(Expense, :count).by(2)

        expect(flash[:notice]).to eq('As despesas serão adicionadas em breve.')
        expect(response).to redirect_to(expenses_path)
      end
    end

    context 'with invalid params' do
      let(:file) { nil }

      it 'does not creates Expenses' do
        post(:create_from_csv, params: { file: file })

        expect(flash[:notice]).to eq('Arquivo CSV é obrigatório.')
        expect(response).to redirect_to(expenses_path)
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      before do
        Timecop.freeze(2020, 2, 20)

        put(:update, params: params)
      end

      after { Timecop.return }

      let(:new_attributes) { { description: 'Book 1984' } }

      let(:params) { { id: expense.to_param, expense: new_attributes } }

      it 'updates the requested expense' do
        expense.reload
        expect(expense.description).to eq('Book 1984')
      end

      it 'shows flash notice' do
        expect(flash[:notice]).to eq('Despesa atualizada.')
      end

      it 'redirects to the expense' do
        expect(response).to redirect_to(expenses_path(expense_month: '2020-02-20'))
      end

      context 'when other month' do
        let(:params) { { id: expense_other_month.to_param, expense: new_attributes, expense_month: '2020-03-01' } }

        it 'redirects to the expense' do
          expect(response).to redirect_to(expenses_path(expense_month: '2020-03-01'))
        end
      end
    end

    context 'with invalid params' do
      it 'does not updates the Expense' do
        expect do
          put(:update, params: { id: expense.to_param, expense: invalid_attributes })
        end.not_to change(Expense, :first)
      end
    end
  end

  describe 'DELETE #destroy' do
    before { Timecop.freeze(2020, 2, 20) }

    after { Timecop.return }

    context 'when current month' do
      let(:params) { { id: expense.id } }

      it 'destroys the requested accept test' do
        expect do
          delete(:destroy, params: params)
        end.to change(Expense, :count).by(-1)
      end

      it 'shows flash notice' do
        delete(:destroy, params: params)
        expect(flash[:notice]).to eq('Despesa removida.')
      end

      it 'redirects to the accept tests list' do
        delete(:destroy, params: params)
        expect(response).to redirect_to(expenses_path(expense_month: '2020-02-20'))
      end
    end

    context 'when other month' do
      let(:params) { { id: expense_other_month.id, expense_month: '2020-03-01' } }

      it 'redirects to the accept tests list' do
        delete(:destroy, params: params)
        expect(response).to redirect_to(expenses_path(expense_month: '2020-03-01'))
      end
    end
  end
end

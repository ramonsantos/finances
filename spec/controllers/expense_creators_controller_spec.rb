# frozen_string_literal: true

require 'rails_helper'

describe ExpenseCreatorsController, type: :controller do
  login_user

  let(:expense_creator) { create(:expense_creator) }

  describe 'GET #index' do
    it 'returns a success response' do
      get(:index)
      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      get(:show, params: { id: expense_creator.to_param })
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      let(:file) { fixture_file_upload('spec/fixtures/expenses.csv') }

      before { create(:place) }

      it 'creates a new Expense' do
        expect do
          post(:create, params: { file: file })
        end.to change(Expense, :count).by(2)

        expect(flash[:notice]).to eq('Processo de criação de despesas finalizado.')
      end
    end

    context 'with invalid params' do
      let(:file) { nil }

      it 'does not creates Expenses' do
        expect do
          post(:create, params: { file: file })
        end.not_to change(Expense, :count)

        expect(flash[:alert]).to eq('Arquivo CSV é obrigatório.')
        expect(response).to redirect_to(expense_creators_path)
      end
    end
  end

  describe 'GET #download_csv_template' do
    it 'returns a success response' do
      get(:download_csv_template)
      expect(response).to be_successful
    end
  end
end

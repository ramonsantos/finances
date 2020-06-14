# frozen_string_literal: true

require 'rails_helper'

feature 'CreateExpensesFromCsv', type: :feature do
  let!(:user) { create(:user) }

  before { login_as(user) }

  feature 'download CSV template' do
    let(:csv_content) do
      "Descrição,Valor,Data,Categoria,Grupo de Despesa,Local,Fixo?,Observações\n" \
      "Plano de Saúde,\"R$ 244,27\",01/01/2020,Saúde,Pessoal,Recife,Sim,\n"
    end

    before do
      visit(expense_creators_path)
      click_on('Baixar Modelo de CSV')
    end

    scenario 'user downloads CSV template file' do
      expect(page.html.force_encoding('UTF-8')).to eq(csv_content)
      expect(page.status_code).to eq(202)
      expect(page.response_headers['Content-Type']).to eq('text/csv')
    end
  end

  feature 'create expenses from CSV file' do
    context 'without CSV file' do
      before { visit(expense_creators_path) }

      scenario "don't create ExpenseCreator" do
        expect do
          click_on('Criar Despesas')
          expect(page).to have_selector('div', text: 'Arquivo CSV é obrigatório')
        end.not_to change(ExpenseCreator, :count)
      end
    end

    context 'with CSV file' do
      before do
        visit(expense_creators_path)
        attach_file('file', 'spec/fixtures/expenses.csv')
      end

      scenario 'creates ExpenseCreator' do
        expect do
          click_on('Criar Despesas')
          expect(page).to have_selector('h1', text: 'Resultados')
          expect(page).to have_selector('div', text: 'Processo de criação de despesas finalizado.')
          expect(page).to have_selector('h3', text: 'Total: 2')
          expect(find(:xpath, '/html/body/main/section/div/div[2]/table/tbody/tr[2]').text).to be_present
        end.to change(ExpenseCreator, :count).by(1)
      end
    end
  end
end

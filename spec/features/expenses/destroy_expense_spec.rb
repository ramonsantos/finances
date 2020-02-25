# frozen_string_literal: true

require 'rails_helper'

feature 'Expenses', type: :feature do
  let!(:user) { create(:user) }
  let(:expense) { create(:expense) }

  feature 'destroy expense' do
    before do
      Timecop.freeze(2020, 2, 20)

      expense
      create(:expense, amount: 8.5)
      create(:expense_other_month)

      login_as(user)
      visit(expenses_path)
    end

    after { Timecop.return }

    scenario 'user visits expenses page and click to remove expense' do
      expect(page).to have_selector('h3', text: 'Total de Despesas: 30,00 R$')

      expect do
        find("a[href=\"/expenses/#{expense.id}?expense_month=2020-02-20\"]").click
      end.to change(Expense, :count).by(-1)

      expect(page).to have_content('Despesa removida.')
      expect(page).to have_selector('h1', text: 'Despesas - Fev/2020')
      expect(page).to have_selector('h3', text: 'Total de Despesas: 8,50 R$')
    end

    scenario 'user visits second expenses page and click to remove expense' do
      visit(expenses_path(expense_month: '2020-03-31'))
      expect(page).to have_selector('h3', text: 'Total de Despesas: 11,50 R$')

      expect do
        click_on('Remover')
      end.to change(Expense, :count).by(-1)

      expect(page).to have_content('Despesa removida.')
      expect(page).to have_selector('h3', text: 'Total de Despesas: 0,00 R$')
      expect(page).to have_selector('h1', text: 'Despesas - Mar/2020')
    end
  end
end

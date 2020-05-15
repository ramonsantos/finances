# frozen_string_literal: true

require 'rails_helper'

feature 'Expenses', type: :feature do
  let!(:user) { create(:user) }

  before do
    Timecop.freeze(2020, 2, 20)

    login_as(user)
  end

  after { Timecop.return }

  feature 'expense report' do
    context 'without expenses' do
      before { visit(report_expenses_path) }

      scenario 'user visits report expense page' do
        expect(page).to have_selector('h1', text: 'Despesas - Fev/2020')
        expect(page).to have_selector(:link_or_button, 'Jan/2020')
        expect(page).to have_selector(:link_or_button, 'Lista de Despesas')
        expect(page).to have_selector(:link_or_button, 'Mar/2020')
      end

      scenario 'user visits report expense page and click on "Lista de Despesas"' do
        find(:xpath, '/html/body/main/section/div[1]/div/a[2]').click

        expect(page).to have_selector(:link_or_button, 'Relatório de Despesas')
      end
    end

    context 'with expenses' do
      let!(:expense_group_work) { create(:expense_group) }
      let!(:expense_group_home) { create(:expense_group_home) }
      let(:expense_category) { ExpenseCategory.find_by(name: 'Saúde') }

      before do
        create(:expense, expense_group_id: expense_group_work.id, amount: 12.56)
        create(:expense, expense_group_id: expense_group_work.id, amount: 52.0)
        create(:expense, expense_group_id: expense_group_home.id, amount: 85.45, expense_category_id: expense_category.id)
        create(:expense, expense_group_id: expense_group_home.id, amount: 5.99)

        visit(report_expenses_path)
      end

      scenario 'user visits report expense page' do
        expect(page).to have_selector('div', text: 'Trabalho')
        expect(page).to have_selector('div', text: 'Alimentação')
        expect(page).to have_selector('div', text: '100,00%')
        expect(page).to have_selector('div', text: 'Total 64,56 R$')

        expect(page).to have_selector('div', text: 'Casa')
        expect(page).to have_selector('div', text: 'Saúde')
        expect(page).to have_selector('div', text: '93,45%')
        expect(page).to have_selector('div', text: '6,55%')
        expect(page).to have_selector('div', text: 'Total 91,44 R$')
      end

      scenario 'user visits previous month report expense page' do
        create(:expense, date: '2020-01-25')

        click_on('Jan/2020')

        expect(page).to have_selector('h1', text: 'Despesas - Jan/2020')
        expect(page).to have_selector(:link_or_button, 'Dez/2019')
        expect(page).to have_selector(:link_or_button, 'Lista de Despesas')
        expect(page).to have_selector(:link_or_button, 'Fev/2020')
        expect(page).to have_selector('div', text: 'Trabalho')
        expect(page).to have_selector('div', text: 'Alimentação')
        expect(page).to have_selector('div', text: '100,00%')
        expect(page).to have_selector('div', text: 'Total 21,50 R$')
      end

      scenario 'user visits previous month report expense page and click on "Lista de Despesas"' do
        click_on('Jan/2020')
        find(:xpath, '/html/body/main/section/div[1]/div/a[2]').click

        expect(page).to have_selector(:link_or_button, 'Relatório de Despesas')
        expect(page).to have_selector('h1', text: 'Despesas - Jan/2020')
      end

      scenario 'user visits next month report expense page' do
        create(:expense_other_month, expense_group_id: expense_group_home.id)

        click_on('Mar/2020')

        expect(page).to have_selector('h1', text: 'Despesas - Mar/2020')
        expect(page).to have_selector(:link_or_button, 'Fev/2020')
        expect(page).to have_selector(:link_or_button, 'Lista de Despesas')
        expect(page).to have_selector(:link_or_button, 'Abr/2020')
        expect(page).to have_selector('div', text: 'Casa')
        expect(page).to have_selector('div', text: 'Alimentação')
        expect(page).to have_selector('div', text: '100,00%')
        expect(page).to have_selector('div', text: 'Total 11,50 R$')
      end

      scenario 'user visits next month report expense page and click on "Lista de Despesas"' do
        click_on('Mar/2020')
        find(:xpath, '/html/body/main/section/div[1]/div/a[2]').click

        expect(page).to have_selector(:link_or_button, 'Relatório de Despesas')
        expect(page).to have_selector('h1', text: 'Despesas - Mar/2020')
      end
    end
  end
end

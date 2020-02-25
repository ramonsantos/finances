# frozen_string_literal: true

require 'rails_helper'

feature 'Expenses', type: :feature do
  let!(:user) { create(:user) }

  before do
    Timecop.freeze(2020, 2, 20)

    login_as(user)
  end

  after { Timecop.return }

  feature 'create expense' do
    context 'without expenses' do
      before { visit(expenses_path) }

      scenario 'user visits expenses page' do
        expect(page).to have_selector('h1', text: 'Despesas - Fev/2020')
        expect(page).to have_selector(:link_or_button, 'Jan/2020')
        expect(page).to have_selector(:link_or_button, 'Fechar despesas do mês')
        expect(page).to have_selector(:link_or_button, 'Mar/2020')

        expect(page).to have_selector('th', text: 'Descrição')
        expect(page).to have_selector('th', text: 'Valor')
        expect(page).to have_selector('th', text: 'Data')
        expect(page).to have_selector('th', text: 'Fixo?')
        expect(page).to have_selector('th', text: 'Categoria')
        expect(page).to have_selector('th', text: 'Local')
        expect(page).to have_selector('th', text: 'Grupo')
        expect(page).to have_selector('th', text: 'Observações')

        expect(page).to have_selector('h3', text: 'Total de Despesas: 0,00 R$')
        expect(page).not_to have_selector(:link_or_button, '1')
      end
    end

    context 'with one expense' do
      let!(:expense) { create(:expense) }

      before { visit(expenses_path) }

      scenario 'user visits expenses page' do
        expect(find(:xpath, '/html/body/main/div[2]/div/table/tbody/tr/td[1]').text).to eq(expense.description)
        expect(find(:xpath, '/html/body/main/div[2]/div/table/tbody/tr/td[2]').text).to eq('21,50 R$')
        expect(find(:xpath, '/html/body/main/div[2]/div/table/tbody/tr/td[3]').text).to eq('15/02/2020')
        expect(find(:xpath, '/html/body/main/div[2]/div/table/tbody/tr/td[4]').text).to eq('Não')
        expect(find(:xpath, '/html/body/main/div[2]/div/table/tbody/tr/td[5]').text).to eq('Alimentação')
        expect(find(:xpath, '/html/body/main/div[2]/div/table/tbody/tr/td[6]').text).to eq('Recife')
        expect(find(:xpath, '/html/body/main/div[2]/div/table/tbody/tr/td[7]').text).to eq('Trabalho')
        expect(find(:xpath, '/html/body/main/div[2]/div/table/tbody/tr/td[8]').text).to be_blank

        expect(page).to have_selector('h3', text: 'Total de Despesas: 21,50 R$')
      end
    end

    context 'with one expense in previous month' do
      before do
        create(:expense, date: '2020-01-25', remark: '12345678901234567890')

        visit(expenses_path)
        click_on('Jan/2020')
      end

      scenario 'user visits expenses page and click to previous month link' do
        expect(page).to have_selector('h1', text: 'Despesas - Jan/2020')
        expect(page).to have_selector(:link_or_button, 'Dez/2019')
        expect(page).to have_selector(:link_or_button, 'Fechar despesas do mês')
        expect(page).to have_selector(:link_or_button, 'Fev/2020')

        expect(find(:xpath, '/html/body/main/div[2]/div/table/tbody/tr/td[3]').text).to eq('25/01/2020')
        expect(find(:xpath, '/html/body/main/div[2]/div/table/tbody/tr/td[8]').text).to eq('12345678901234567890')

        expect(page).to have_selector('h3', text: 'Total de Despesas: 21,50 R$')
      end
    end

    context 'with one expense in next month' do
      before do
        create(:expense, date: '2020-03-01', remark: '123456789012345678901')
        visit(expenses_path(expense_month: '2020-03-31'))
      end

      scenario 'user visits next month expenses page' do
        expect(page).to have_selector('h1', text: 'Despesas - Mar/2020')
        expect(page).to have_selector(:link_or_button, 'Fev/2020')
        expect(page).to have_selector(:link_or_button, 'Fechar despesas do mês')
        expect(page).to have_selector(:link_or_button, 'Abr/2020')

        expect(find(:xpath, '/html/body/main/div[2]/div/table/tbody/tr/td[3]').text).to eq('01/03/2020')
        expect(find(:xpath, '/html/body/main/div[2]/div/table/tbody/tr/td[8]').text).to eq('12345678901234567...')

        expect(page).to have_selector('h3', text: 'Total de Despesas: 21,50 R$')
      end
    end

    context 'when expense page has pagination' do
      before do
        21.times.each { create(:expense) }

        visit(expenses_path)
      end

      scenario 'user visits expenses page' do
        expect(page).to have_selector(:link_or_button, '1')
        expect(page).to have_selector(:link_or_button, '2')
        expect(page).to have_selector(:link_or_button, '›')
        expect(page).to have_selector(:link_or_button, '»')
        expect(page).not_to have_selector(:link_or_button, '3')

        expect(find(:xpath, '/html/body/main/div[2]/div/table/tbody/tr[20]')).to be_present
        expect(page).to have_selector('h3', text: 'Total de Despesas: 451,50 R$')
      end

      scenario 'user visits second expenses page' do
        click_on('2')
        expect(page).to have_selector(:link_or_button, '‹')
        expect(page).to have_selector(:link_or_button, '«')
        expect(page).to have_selector(:link_or_button, '1')
        expect(page).to have_selector(:link_or_button, '2')
        expect(page).not_to have_selector(:link_or_button, '3')

        expect(find(:xpath, '/html/body/main/div[2]/div/table/tbody/tr')).to be_present
        expect(page).to have_selector('h3', text: 'Total de Despesas: 451,50 R$')
      end
    end
  end
end

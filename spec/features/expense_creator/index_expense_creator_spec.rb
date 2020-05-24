# frozen_string_literal: true

require 'rails_helper'

feature 'ExpenseCreators', type: :feature do
  let!(:user) { create(:user) }

  before { login_as(user) }

  feature 'list expense_creators' do
    context 'without expense_creators' do
      before { visit(expense_creators_path) }

      scenario 'user visits expense_creators page' do
        expect(page).to have_selector('h1', text: 'Criar Despesas por CSV')
        expect(page).to have_selector('label', text: 'Escolher Arquivo')
        expect(page).to have_selector(:link_or_button, 'Criar Despesas')
        expect(page).to have_selector(:link_or_button, 'Baixar Modelo de CSV')

        expect(page).not_to have_selector('h2', text: 'Anteriores')
        expect(page).not_to have_selector('th', text: 'Data de Criação')
        expect(page).not_to have_selector('th', text: 'Total')
      end
    end

    context 'with expense_creators' do
      context 'with one expense_creator' do
        let!(:expense_creator) { create(:expense_creator, date: DateTime.parse('2020/5/21 14:00:00 -3')) }

        before { visit(expense_creators_path) }

        scenario 'user visits expense_creators page' do
          expect(page).to have_selector('h1', text: 'Criar Despesas por CSV')
          expect(page).to have_selector('label', text: 'Escolher Arquivo')
          expect(page).to have_selector(:link_or_button, 'Criar Despesas')
          expect(page).to have_selector(:link_or_button, 'Baixar Modelo de CSV')
          expect(page).to have_selector('h2', text: 'Anteriores')
          expect(page).to have_selector('th', text: 'Data de Criação')
          expect(page).to have_selector('th', text: 'Total')
          expect(find(:xpath, '/html/body/main/section/div/div[1]/table/tbody/tr[1]/td[1]').text).to eq('21/05/2020 - 14:00:00')
          expect(find(:xpath, '/html/body/main/section/div/div[1]/table/tbody/tr[1]/td[2]').text).to eq('1')
          expect(page).to have_link('Detalhes', href: expense_creator_path(expense_creator.id))
        end
      end

      context 'with two expense_creators' do
        let!(:expense_creator1) { create(:expense_creator, date: DateTime.parse('2020/5/21 14:00:00 -3')) }
        let!(:expense_creator2) { create(:expense_creator, date: DateTime.parse('2020/5/01 16:20:42 -3')) }

        before do
          create(:expense_creator_result, expense_creator_id: expense_creator2.id)
          visit(expense_creators_path)
        end

        scenario 'user visits expense_creators page' do
          expect(page).to have_selector('h1', text: 'Criar Despesas por CSV')
          expect(page).to have_selector('label', text: 'Escolher Arquivo')
          expect(page).to have_selector(:link_or_button, 'Criar Despesas')
          expect(page).to have_selector(:link_or_button, 'Baixar Modelo de CSV')
          expect(page).to have_selector('h2', text: 'Anteriores')
          expect(page).to have_selector('th', text: 'Data de Criação')
          expect(page).to have_selector('th', text: 'Total')
          expect(find(:xpath, '/html/body/main/section/div/div[1]/table/tbody/tr[1]/td[1]').text).to eq('21/05/2020 - 14:00:00')
          expect(find(:xpath, '/html/body/main/section/div/div[1]/table/tbody/tr[1]/td[2]').text).to eq('1')
          expect(page).to have_link('Detalhes', href: expense_creator_path(expense_creator1.id))
          expect(find(:xpath, '/html/body/main/section/div/div[1]/table/tbody/tr[2]/td[1]').text).to eq('01/05/2020 - 16:20:42')
          expect(find(:xpath, '/html/body/main/section/div/div[1]/table/tbody/tr[2]/td[2]').text).to eq('2')
          expect(page).to have_link('Detalhes', href: expense_creator_path(expense_creator2.id))
        end
      end

      context 'with many expense_creators' do
        before do
          21.times.each { create(:expense_creator) }

          visit(expense_creators_path)
        end

        scenario 'user visits expense_creators page' do
          expect(page).to have_selector(:link_or_button, '1')
          expect(page).to have_selector(:link_or_button, '2')
          expect(page).to have_selector(:link_or_button, '›')
          expect(page).to have_selector(:link_or_button, '»')
          expect(page).not_to have_selector(:link_or_button, '3')

          expect(find(:xpath, '/html/body/main/section/div/div[1]/table/tbody/tr[20]')).to be_present
        end

        scenario 'user visits second expense_creators page' do
          click_on('2')
          expect(page).to have_selector(:link_or_button, '‹')
          expect(page).to have_selector(:link_or_button, '«')
          expect(page).to have_selector(:link_or_button, '1')
          expect(page).to have_selector(:link_or_button, '2')
          expect(page).not_to have_selector(:link_or_button, '3')

          expect(find(:xpath, '/html/body/main/section/div/div[1]/table/tbody/tr')).to be_present
        end
      end
    end
  end
end

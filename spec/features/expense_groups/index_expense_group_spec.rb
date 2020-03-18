# frozen_string_literal: true

require 'rails_helper'

feature 'ExpenseGroup', type: :feature do
  let!(:user) { create(:user) }

  before { login_as(user) }

  feature 'list expense groups' do
    context 'without expense groups ' do
      scenario 'user visits expense groups page' do
        visit(expense_groups_path)

        expect(page).to have_selector('h1', text: 'Adicionar Grupo de Despesa')
        expect(page).to have_selector(:link_or_button, 'Salvar')
        expect(page).to have_selector('input', id: 'expense_group_name', text: '')
      end
    end

    context 'with expense groups ' do
      before do
        create(:expense_group)
        visit(expense_groups_path)
      end

      scenario 'user visits expense groups page' do
        expect(page).to have_selector('h1', text: 'Grupos de Despesa')
        expect(page).to have_selector('th', text: 'Grupo')
        expect(page).to have_selector('td', text: 'Trabalho')
        expect(page).to have_selector(:link_or_button, 'Remover')
      end
    end
  end

  feature 'create expense group' do
    let(:new_expense_group_id) { ExpenseGroup.find_by(name: 'Pessoal').id }

    scenario 'user creates expense group' do
      visit(expense_groups_path)
      fill_in('expense_group_name', with: 'Pessoal')
      click_on('Salvar')

      expect(page).to have_selector('div', text: 'Grupo de Despesas adicionado.')
      expect(page).to have_selector('td', text: 'Pessoal')
      expect(find(:xpath, "//a[@href='/expense_groups/#{new_expense_group_id}']").text).to eq('Remover')
    end
  end

  feature 'remove expense group' do
    let!(:expense_group) { create(:expense_group) }

    context 'when one expense group' do
      scenario 'user remove one expense group' do
        expect do
          visit(expense_groups_path)
          find(:xpath, "//a[@href='/expense_groups/#{expense_group.id}']").click

          expect(page).to have_selector('div', text: 'Grupo de Despesas removido.')
          expect(page).not_to have_selector('h1', text: 'Grupos de Despesa')
          expect(page).not_to have_selector('th', text: 'Grupo')
          expect(page).not_to have_selector('td', text: 'Recife')
          expect(page).to have_selector('input', id: 'expense_group_name', text: '')
        end.to change(ExpenseGroup, :count).by(-1)
      end
    end

    context 'when many expense groups' do
      before { create(:expense_group_home) }

      scenario 'user remove one expense group' do
        expect do
          visit(expense_groups_path)
          find(:xpath, "//a[@href='/expense_groups/#{expense_group.id}']").click

          expect(page).to have_selector('div', text: 'Grupo de Despesas removido.')
          expect(page).to have_selector('h1', text: 'Grupos de Despesa')
          expect(page).to have_selector('th', text: 'Grupo')
          expect(page).to have_selector('td', text: 'Casa')
          expect(page).not_to have_selector('td', text: 'Trabalho')
          expect(page).to have_selector('input', id: 'expense_group_name', text: '')
        end.to change(ExpenseGroup, :count).by(-1)
      end
    end

    context 'when expense group with expenses' do
      before { create(:expense, expense_group_id: expense_group.id) }

      scenario 'user remove one expense group' do
        expect do
          visit(expense_groups_path)
          find(:xpath, "//a[@href='/expense_groups/#{expense_group.id}']").click

          expect(page).to have_selector('div', text: 'Ocorreu um erro ao remover o grupo de despesas.')
          expect(page).to have_selector('h1', text: 'Grupos de Despesa')
          expect(page).to have_selector('th', text: 'Grupo')
          expect(page).to have_selector('td', text: 'Trabalho')
          expect(page).to have_selector('input', id: 'expense_group_name', text: '')
        end.not_to change(ExpenseGroup, :count)
      end
    end
  end
end

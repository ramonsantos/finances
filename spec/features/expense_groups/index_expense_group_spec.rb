# frozen_string_literal: true

require 'rails_helper'

feature 'ExpenseGroup', type: :feature do
  let!(:user) { create(:user) }

  before { login_as(user) }

  feature 'list expense groups' do
    context 'with one expense group' do
      before { visit(expense_groups_path) }

      scenario 'user visits expense groups page' do
        expect(page).to have_selector('h1', text: 'Grupos de Despesa')
        expect(page).to have_selector('th', text: 'Grupo')
        expect(page).to have_selector('td', text: 'Pessoal')
        expect(page).not_to have_selector(:link_or_button, 'Remover')
      end
    end

    context 'with many expense groups' do
      before do
        create(:expense_group_home)
        visit(expense_groups_path)
      end

      scenario 'user visits expense groups page' do
        expect(page).to have_selector('h1', text: 'Grupos de Despesa')
        expect(page).to have_selector('th', text: 'Grupo')
        expect(page).to have_selector('td', text: 'Pessoal')
        expect(page).to have_selector(:link_or_button, 'Remover')
      end
    end

    context 'with one expense group associated to an expense' do
      let(:expense_group) { create(:expense_group_home) }

      before do
        create(:expense, expense_group_id: expense_group.id)
        visit(expense_groups_path)
      end

      scenario 'user visits expense groups page' do
        expect(page).to have_selector('h1', text: 'Grupos de Despesa')
        expect(page).to have_selector('th', text: 'Grupo')
        expect(page).to have_selector('td', text: 'Pessoal')
        expect(find(:xpath, '/html/body/main/section/div/table/tbody/tr[1]/td[2]').text).to be_blank
        expect(find(:xpath, '/html/body/main/section/div/table/tbody/tr[2]/td[2]').text).to eq('Remover')
      end
    end
  end

  feature 'create expense group' do
    let(:new_expense_group_id) { ExpenseGroup.find_by(name: 'Pessoal').id }

    before { visit(expense_groups_path) }

    scenario 'user creates expense group' do
      expect(page).not_to have_selector(:link_or_button, 'Remover')
      fill_in('expense_group_name', with: 'Pessoal')
      click_on('Salvar')
      expect(page).to have_selector('div', text: 'Grupo de Despesas adicionado.')
      expect(page).to have_selector('td', text: 'Pessoal')
      expect(find(:xpath, "//a[@href='/expense_groups/#{new_expense_group_id}']").text).to eq('Remover')
    end
  end

  feature 'remove expense group' do
    let!(:expense_group) { create(:expense_group_home) }

    before { visit(expense_groups_path) }

    scenario 'user remove one expense group' do
      expect do
        find(:xpath, "//a[@href='/expense_groups/#{expense_group.id}']").click
        expect(page).to have_selector('div', text: 'Grupo de Despesas removido.')
        expect(page).to have_selector('h1', text: 'Grupos de Despesa')
        expect(page).to have_selector('th', text: 'Grupo')
        expect(page).to have_selector('td', text: 'Pessoal')
        expect(page).not_to have_selector('td', text: 'Casa')
        expect(page).to have_selector('input', id: 'expense_group_name', text: '')
      end.to change(ExpenseGroup, :count).by(-1)
    end
  end
end

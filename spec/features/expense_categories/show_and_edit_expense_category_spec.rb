# frozen_string_literal: true

require 'rails_helper'

feature 'ExpenseCategory', type: :feature do
  let!(:user) { create(:user) }
  let!(:expense_category) { create(:expense_category) }

  before do
    login_as(user)
    visit(expense_category_path(id: expense_category.id))
  end

  feature 'show and edit expense_category' do
    scenario 'user visits expense_category page' do
      expect(page).to have_selector('h1', text: 'Editar Categoria de Despesa')
      expect(find(id: 'expense_category_name').value).to eq('Saúde')
      expect(find(id: 'expense_category_description').value).to be_blank
      expect(page).to have_selector(:link_or_button, 'Salvar')
    end

    scenario 'user edits a expense_category' do
      fill_in('Descrição', with: 'Gastos com Remédios')

      find('input[name="commit"]').click

      expense_category.reload
      expect(expense_category.name).to eq('Saúde')
      expect(expense_category.description).to eq('Gastos com Remédios')
      expect(page).to have_content('Categoria de Despesa atualizada.')
    end
  end
end

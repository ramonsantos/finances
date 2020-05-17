# frozen_string_literal: true

require 'rails_helper'

feature 'ExpenseCategory', type: :feature do
  let!(:user) { create(:user) }

  feature 'create expense_category' do
    before do
      login_as(user)
      visit(new_expense_category_path)
    end

    scenario 'user visits new expense_category page' do
      expect(page).to have_selector('h1', text: 'Adicionar Categoria de Despesa')
      expect(page).to have_selector('input', id: 'expense_category_name')
      expect(page).to have_selector('textarea', id: 'expense_category_description')
      expect(page).to have_selector(:link_or_button, 'Salvar')
    end

    feature 'user creates a expense_category' do
      let(:expense_category) { ExpenseCategory.where(user: user).last }

      before do
        fill_in('Nome',      with: 'Transporte Público')
        fill_in('Descrição', with: 'Despesas com Transporte Público')
      end

      scenario 'creates expense category' do
        expect { find('input[name="commit"]').click }.to change(ExpenseCategory, :count).by(1)
        expect(expense_category.name).to eq('Transporte Público')
        expect(expense_category.description).to eq('Despesas com Transporte Público')
        expect(page).to have_content('Categoria de Despesa adicionada.')
      end
    end
  end
end

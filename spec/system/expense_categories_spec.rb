# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Expense categories', type: :system do
  describe 'index' do
    context 'when no categories exist' do
      it 'shows the empty state' do
        visit expense_categories_path

        expect(page).to have_text('Nenhuma categoria cadastrada.')
      end
    end

    context 'when a category exists' do
      before { create(:expense_category, name: 'Moradia', description: 'Aluguel') }

      it 'lists the category with expense count' do
        visit expense_categories_path

        expect(page).to have_text('Moradia')
        expect(page).to have_text('Aluguel')
        expect(page).to have_text('0')
      end
    end
  end

  describe 'create' do
    context 'when success' do
      it 'adds a category and redirects with notice' do
        visit new_expense_category_path
        fill_in 'Name', with: 'Moradia'
        fill_in 'Description', with: 'Aluguel e condomínio'
        click_button 'Salvar'

        expect(page).to have_text('Categoria adicionada.')
        expect(page).to have_text('Moradia')
      end
    end

    context 'when name is duplicate' do
      before { create(:expense_category, name: 'Moradia') }

      it 'shows validation error' do
        visit new_expense_category_path
        fill_in 'Name', with: 'moradia'
        click_button 'Salvar'

        expect(page).to have_text('já está em uso')
      end
    end
  end

  describe 'update' do
    context 'when success' do
      before { create(:expense_category, name: 'Moradia') }

      it 'updates the category' do
        category = ExpenseCategory.find_by!(name: 'Moradia')

        visit expense_category_path(category)
        fill_in 'Description', with: 'Condomínio'
        click_button 'Salvar'

        expect(page).to have_text('Categoria atualizada.')
        expect(page).to have_text('Condomínio')
      end
    end
  end

  describe 'destroy' do
    context 'when success' do
      before { create(:expense_category, name: 'Moradia') }

      it 'removes the category' do
        category = ExpenseCategory.find_by!(name: 'Moradia')

        visit expense_category_path(category)
        click_button 'Excluir'

        expect(page).to have_text('Categoria removida.')
        expect(page).to have_text('Nenhuma categoria cadastrada.')
      end
    end

    context 'when category has dependent expenses' do
      let!(:category) { create(:expense_category, name: 'Alimentação') }
      let!(:group) { create(:expense_group, name: 'Pessoal') }

      before do
        create(
          :expense,
          description: 'Mercado',
          date: Date.new(2026, 3, 2),
          expense_category: category,
          expense_group: group
        )
      end

      it 'shows destroy failure alert' do
        visit expense_category_path(category)
        click_button 'Excluir'

        expect(page).to have_text('Não é possível excluir uma categoria com despesas vinculadas.')
        expect(page).to have_text('Alimentação')
      end
    end
  end
end

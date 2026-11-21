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
        expect(page).to have_css('label', text: 'Excluir')
      end
    end
  end

  describe 'create' do
    context 'when success' do
      it 'adds a category and redirects with notice' do
        visit expense_categories_path
        find('label', text: 'Nova categoria', match: :first).click
        dialog = find(:xpath, "//*[@id='expense-category-new-modal-title']/ancestor::*[@role='dialog'][1]")
        within(dialog) do
          fill_in 'Name', with: 'Moradia'
          fill_in 'Description', with: 'Aluguel e condomínio'
          click_button 'Salvar'
        end

        expect(page).to have_text('Categoria adicionada.')
        expect(page).to have_text('Moradia')
      end
    end

    context 'when canceling' do
      it 'returns to the index without saving' do
        visit expense_categories_path
        find('label', text: 'Nova categoria', match: :first).click
        dialog = find(:xpath, "//*[@id='expense-category-new-modal-title']/ancestor::*[@role='dialog'][1]")
        within(dialog) { click_button 'Cancelar' }

        expect(page).to have_text('Nenhuma categoria cadastrada.')
      end
    end

    context 'when name is duplicate' do
      before { create(:expense_category, name: 'Moradia') }

      it 'shows validation error' do
        visit expense_categories_path
        find('label', text: 'Nova categoria', match: :first).click
        dialog = find(:xpath, "//*[@id='expense-category-new-modal-title']/ancestor::*[@role='dialog'][1]")
        within(dialog) do
          fill_in 'Name', with: 'moradia'
          click_button 'Salvar'
        end

        expect(page).to have_text('já está em uso')
      end
    end
  end

  describe 'update' do
    context 'when success' do
      before { create(:expense_category, name: 'Moradia') }

      it 'updates the category' do
        category = ExpenseCategory.find_by!(name: 'Moradia')

        visit expense_categories_path
        find("label[for='expense-category-edit-#{category.id}']").click
        dialog = find(:xpath, "//*[@id='expense-category-edit-#{category.id}-title']/ancestor::*[@role='dialog'][1]")
        within(dialog) do
          fill_in 'Description', with: 'Condomínio'
          click_button 'Salvar'
        end

        expect(page).to have_text('Categoria atualizada.')
        expect(page).to have_text('Condomínio')
      end
    end

    context 'when canceling' do
      before { create(:expense_category, name: 'Moradia') }

      it 'returns to the index' do
        category = ExpenseCategory.find_by!(name: 'Moradia')

        visit expense_categories_path
        find("label[for='expense-category-edit-#{category.id}']").click
        dialog = find(:xpath, "//*[@id='expense-category-edit-#{category.id}-title']/ancestor::*[@role='dialog'][1]")
        within(dialog) { click_button 'Cancelar' }

        expect(page).to have_text('Moradia')
      end
    end
  end

  describe 'destroy' do
    context 'when success' do
      before { create(:expense_category, name: 'Moradia') }

      it 'removes the category from the index' do
        visit expense_categories_path
        confirm_destroy_from_modal

        expect(page).to have_text('Categoria removida.')
        expect(page).to have_text('Nenhuma categoria cadastrada.')
      end
    end

    context 'when category has dependent expenses' do
      let!(:category) { create(:expense_category, name: 'Alimentação') }
      let!(:payment_method) { create(:payment_method, name: 'Dinheiro') }

      before do
        create(
          :expense,
          description: 'Mercado',
          date: Date.new(2026, 3, 2),
          expense_category: category,
          payment_method: payment_method
        )
      end

      it 'shows a disabled remove control' do
        visit expense_categories_path

        expect(page).to have_css('label', text: 'Editar')
        expect(page).to have_css('[aria-disabled="true"]', text: 'Excluir')
        expect(page).to have_no_button('Excluir')
      end
    end
  end
end

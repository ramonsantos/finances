# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Expense groups', type: :system do
  describe 'index' do
    context 'when no groups exist' do
      it 'shows the empty state' do
        visit expense_groups_path

        expect(page).to have_text('Nenhum grupo cadastrado.')
      end
    end

    context 'when a group exists' do
      before { create(:expense_group, name: 'Trabalho') }

      it 'lists the group with expense count' do
        visit expense_groups_path

        expect(page).to have_text('Trabalho')
        expect(page).to have_text('0 despesas')
      end
    end
  end

  describe 'create' do
    context 'when success' do
      it 'adds a group from the index form' do
        visit expense_groups_path
        fill_in 'Nome do grupo', with: 'Trabalho'
        click_button 'Salvar'

        expect(page).to have_text('Grupo adicionado.')
        expect(page).to have_text('Trabalho')
      end
    end

    context 'when name is duplicate' do
      before { create(:expense_group, name: 'Trabalho') }

      it 'shows validation error' do
        visit expense_groups_path
        fill_in 'Nome do grupo', with: 'trabalho'
        click_button 'Salvar'

        expect(page).to have_text('já está em uso')
      end
    end
  end

  describe 'destroy' do
    context 'when success' do
      before { create(:expense_group, name: 'Trabalho') }

      it 'removes the group' do
        visit expense_groups_path
        click_button 'Excluir'

        expect(page).to have_text('Grupo removido.')
        expect(page).to have_text('Nenhum grupo cadastrado.')
      end
    end

    context 'when group has dependent expenses' do
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
        visit expense_groups_path
        click_button 'Excluir'

        expect(page).to have_text('Não é possível excluir um grupo com despesas vinculadas.')
        expect(page).to have_text('Pessoal')
      end
    end
  end
end

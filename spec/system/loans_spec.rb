# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Loans', type: :system do
  describe 'index' do
    context 'when listing open loans' do
      before do
        create(:loan, person: 'Maria', borrowed_amount: 150, received_amount: nil)
        create(:loan, person: 'Pedro', borrowed_amount: 50, received_amount: 80, received_at: Date.new(2026, 1, 10))
      end

      it 'shows open loans and total to receive' do
        visit loans_path

        expect(page).to have_text('Empréstimos em aberto')
        expect(page).to have_text('Maria')
        expect(page).to have_no_text('Pedro')
        expect(page).to have_text('R$ 150,00')
      end
    end

    context 'when toggling to received loans' do
      before do
        create(:loan, person: 'Maria', borrowed_amount: 150, received_amount: nil)
        create(:loan, person: 'Pedro', borrowed_amount: 50, received_amount: 80, received_at: Date.new(2026, 1, 10))
      end

      it 'shows only received loans' do
        visit loans_path
        click_link 'Ver recebidos'

        expect(page).to have_text('Empréstimos recebidos')
        expect(page).to have_text('Pedro')
        expect(page).to have_no_text('Maria')
      end
    end

    context 'when there are no loans' do
      it 'shows the empty state for open loans' do
        visit loans_path

        expect(page).to have_text('Nenhum empréstimo nesta lista.')
      end
    end
  end

  describe 'create' do
    context 'when success' do
      it 'adds a loan to the open list' do
        Timecop.freeze(Date.new(2026, 3, 15)) do
          visit new_loan_path
          fill_in 'Pessoa', with: 'Ana'
          fill_in 'Descrição', with: 'Empréstimo teste'
          fill_in 'Valor emprestado', with: '300.00'
          fill_in 'Data do empréstimo', with: '2026-03-15'
          click_button 'Salvar'

          expect(page).to have_text('Empréstimo adicionado.')
          expect(page).to have_text('Ana')
          expect(page).to have_text('Empréstimo teste')
        end
      end
    end
  end

  describe 'update' do
    context 'when marking as received' do
      it 'sets received_at when received amount is filled' do
        Timecop.freeze(Date.new(2025, 3, 1)) do
          loan = create(:loan, borrowed_amount: 200)

          visit loan_path(loan)
          fill_in 'Valor emprestado', with: '200.00'
          fill_in 'Valor recebido', with: '200.00'
          click_button 'Salvar'

          expect(page).to have_text('Empréstimo atualizado')
          expect(loan.reload.received_at).to eq(Date.new(2025, 3, 1))
        end
      end
    end

    context 'when received date is set without received amount' do
      let(:loan) { create(:loan, borrowed_amount: 200) }

      it 'shows validation error on the edit screen' do
        visit loan_path(loan)
        fill_in 'Recebido em', with: '2026-03-01'
        click_button 'Salvar'

        expect(page).to have_text('Recebido em não é válido')
      end
    end
  end

  describe 'destroy' do
    context 'when success' do
      before { create(:loan, person: 'Carlos', borrowed_amount: 100, received_amount: nil) }

      it 'removes the loan from the open list' do
        visit loans_path
        click_button 'Excluir'

        expect(page).to have_text('Empréstimo removido.')
        expect(page).to have_text('Nenhum empréstimo nesta lista.')
      end
    end
  end
end

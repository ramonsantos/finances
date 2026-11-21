# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Expenses', type: :system do
  let!(:category) { create(:expense_category, name: 'Alimentação') }
  let!(:payment_method) { create(:payment_method, name: 'Cartão Nubank') }

  it 'lists monthly expenses and creates a new one' do
    create(:expense, description: 'Padaria', amount: 15, date: Time.zone.today, expense_category: category, payment_method: payment_method)

    visit expenses_path

    expect(page).to have_text('Padaria')
    expect(page).to have_text('R$')

    visit new_expense_path
    fill_in 'Descrição', with: 'Feira'
    fill_in 'Valor', with: '30.00'
    fill_in 'Data', with: Time.zone.today.to_s
    select 'Alimentação', from: 'Categoria'
    select 'Cartão Nubank', from: 'Forma de pagamento'
    click_button 'Salvar'

    expect(page).to have_text('Despesa adicionada')
    expect(page).to have_text('Feira')
  end

  context 'when the month has no expenses' do
    it 'shows the empty state' do
      Timecop.freeze(Date.new(2026, 3, 15)) do
        visit expenses_path

        expect(page).to have_text('Nenhuma despesa neste mês.')
      end
    end
  end

  context 'when navigating between months' do
    let(:march_expense_date) { Date.new(2026, 3, 10) }
    let(:february_expense_date) { Date.new(2026, 2, 10) }

    before do
      create(
        :expense,
        description: 'Mercado março',
        amount: 10,
        date: march_expense_date,
        expense_category: category,
        payment_method: payment_method
      )
      create(
        :expense,
        description: 'Mercado fevereiro',
        amount: 20,
        date: february_expense_date,
        expense_category: category,
        payment_method: payment_method
      )
    end

    it 'filters expenses by selected month' do
      Timecop.freeze(Date.new(2026, 3, 15)) do
        visit expenses_path

        expect(page).to have_text('Mercado março')
        expect(page).to have_no_text('Mercado fevereiro')

        click_link 'Fev/2026'

        expect(page).to have_text('Mercado fevereiro')
        expect(page).to have_no_text('Mercado março')
      end
    end
  end

  context 'when creating a fixed expense' do
    it 'shows the fixed badge on the list' do
      Timecop.freeze(Date.new(2026, 3, 15)) do
        visit new_expense_path
        fill_in 'Descrição', with: 'Aluguel'
        fill_in 'Valor', with: '1200.00'
        fill_in 'Data', with: '2026-03-15'
        select 'Alimentação', from: 'Categoria'
        select 'Cartão Nubank', from: 'Forma de pagamento'
        check 'Despesa fixa'
        click_button 'Salvar'

        expect(page).to have_text('Despesa adicionada')
        expect(page).to have_text('Sim')
      end
    end
  end

  context 'when updating an expense' do
    let(:expense_date) { Date.new(2026, 3, 5) }

    before do
      create(
        :expense,
        description: 'Padaria',
        amount: 15,
        date: expense_date,
        expense_category: category,
        payment_method: payment_method
      )
    end

    it 'saves changes from the edit screen' do
      Timecop.freeze(Date.new(2026, 3, 15)) do
        visit expenses_path
        click_link 'Editar'

        fill_in 'Descrição', with: 'Padaria atualizada'
        click_button 'Salvar'

        expect(page).to have_text('Despesa atualizada.')
        expect(page).to have_field('Descrição', with: 'Padaria atualizada')
      end
    end
  end

  context 'when destroying an expense' do
    let(:expense_date) { Date.new(2026, 3, 5) }

    before do
      create(
        :expense,
        description: 'Remover',
        amount: 5,
        date: expense_date,
        expense_category: category,
        payment_method: payment_method
      )
    end

    it 'removes the row from the monthly list' do
      Timecop.freeze(Date.new(2026, 3, 15)) do
        visit expenses_path
        click_button 'Excluir'

        expect(page).to have_text('Despesa removida.')
        expect(page).to have_text('Nenhuma despesa neste mês.')
      end
    end
  end
end

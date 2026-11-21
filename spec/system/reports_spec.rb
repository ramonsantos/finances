# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Expense report', type: :system do
  it 'displays totals per category' do
    category = create(:expense_category, name: 'Alimentação')
    payment_method = create(:payment_method, name: 'Swile')
    create(:expense, amount: 50, expense_category: category, payment_method: payment_method, date: Time.zone.today)
    create(:expense, amount: 50, expense_category: category, payment_method: payment_method, date: Time.zone.today)

    visit report_expenses_path

    expect(page).to have_text('Alimentação')
    expect(page).to have_text('R$ 100,00')
    expect(page).to have_text('Swile')
  end

  context 'when the month has no expenses' do
    it 'shows the empty state' do
      Timecop.freeze(Date.new(2026, 3, 15)) do
        visit report_expenses_path

        expect(page).to have_text('Nenhuma despesa neste mês.')
      end
    end
  end

  context 'when navigating between months' do
    let(:category) { create(:expense_category, name: 'Alimentação') }
    let(:payment_method) { create(:payment_method, name: 'Pix Nubank') }

    before do
      create(:expense, amount: 40, expense_category: category, payment_method: payment_method, date: Date.new(2026, 2, 5))
      create(:expense, amount: 60, expense_category: category, payment_method: payment_method, date: Date.new(2026, 3, 5))
    end

    it 'shows totals for the selected month only' do
      Timecop.freeze(Date.new(2026, 3, 15)) do
        visit report_expenses_path

        expect(page).to have_text('R$ 60,00')

        click_link 'Fev/2026'

        expect(page).to have_text('R$ 40,00')
      end
    end
  end

  context 'when using the link to the expense list' do
    let(:category) { create(:expense_category, name: 'Alimentação') }
    let(:payment_method) { create(:payment_method, name: 'Dinheiro') }

    before do
      create(
        :expense,
        description: 'Feira',
        amount: 25,
        expense_category: category,
        payment_method: payment_method,
        date: Date.new(2026, 3, 2)
      )
    end

    it 'opens the monthly expense list' do
      Timecop.freeze(Date.new(2026, 3, 15)) do
        visit report_expenses_path
        click_link 'Ver lista'

        expect(page).to have_text('Despesas — Mar/2026')
        expect(page).to have_text('Feira')
      end
    end
  end
end

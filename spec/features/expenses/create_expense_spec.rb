# frozen_string_literal: true

require 'rails_helper'

feature 'Expenses', type: :feature do
  let!(:user) { create(:user) }

  before do
    Timecop.freeze(2020, 2, 20)

    [:place, :place_surubim].each { |place| create(place) }
    [:expense_group, :expense_group_home].each { |expense_group| create(expense_group) }

    login_as(user)
  end

  after { Timecop.return }

  feature 'create expense' do
    before do
      visit(new_expense_path)
    end

    let(:category_options) do
      [
        'Alimentação',
        'Educação',
        'Lazer',
        'Saúde',
        'Transporte'
      ]
    end

    scenario 'user visits new expense page' do
      expect(page).to have_selector('h1', text: 'Adicionar Despesa')
      expect(page).to have_selector('input', id: 'expense_description')
      expect(page).to have_selector('input', id: 'expense_amount')
      expect(page).to have_selector('input', id: 'expense_date')
      expect(page).to have_selector('input', id: 'expense_fixed')
      expect(page).to have_field('expense_fixed', checked: false)
      expect(page).to have_select('Categoria', options: category_options)
      expect(page).to have_select('Local', options: ['Recife', 'Surubim'])
      expect(page).to have_select('Grupo de Despesa', options: ['Trabalho', 'Casa'])
      expect(page).to have_selector('textarea', id: 'expense_remark')
      expect(page).to have_selector(:link_or_button, 'Salvar')
    end

    feature 'user creates a expense' do
      let(:expense) { Expense.includes(:place, :expense_group).last }

      before do
        fill_in('Descrição', with: 'Book')
        fill_in('Valor', with: '14.99')
      end

      scenario 'with other values' do
        expect do
          find('input[name="commit"]').click
        end.to change(Expense, :count).by(1)

        expect(expense.description).to eq('Book')
        expect(expense.amount).to eq(14.99)
        expect(expense.date).to eq(Date.parse('Feb 20 2020'))
        expect(expense.fixed).to be_falsey
        expect(expense.expense_category.name).to eq('Alimentação')
        expect(expense.place.name).to eq('Recife')
        expect(expense.expense_group.name).to eq('Trabalho')
        expect(expense.remark).to be_blank
      end

      scenario 'with default values' do
        fill_in('Data da Compra', with: I18n.l(Date.parse('Feb 21 2020'), format: '%Y-%m-%d'))
        fill_in('Observações', with: 'By credit card')
        find('#expense_fixed').set(true)
        find('#expense_expense_category_id').select('Saúde')
        find('#expense_place_id').select('Surubim')
        find('#expense_expense_group_id').select('Casa')

        expect do
          find('input[name="commit"]').click
        end.to change(Expense, :count).by(1)

        expect(expense.description).to eq('Book')
        expect(expense.amount).to eq(14.99)
        expect(expense.date).to eq(Date.parse('Feb 21 2020'))
        expect(expense.fixed).to be_truthy
        expect(expense.expense_category.name).to eq('Saúde')
        expect(expense.place.name).to eq('Surubim')
        expect(expense.expense_group.name).to eq('Casa')
        expect(expense.remark).to eq('By credit card')
      end
    end
  end
end

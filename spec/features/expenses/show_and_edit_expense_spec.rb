# frozen_string_literal: true

require 'rails_helper'

feature 'Expenses', type: :feature do
  let!(:user) { create(:user) }
  let(:expense) { create(:expense) }
  let(:place) { create(:place) }
  let(:expense_group) { create(:expense_group) }
  let!(:expense_other_month) { create(:expense_other_month) }

  before do
    Timecop.freeze(2020, 2, 20)
    place
    expense_group
    create(:place_surubim)
    create(:expense_group_home)
    expense

    login_as(user)
  end

  after { Timecop.return }

  feature 'show and edit expense' do
    scenario 'user visits expense page' do
      visit(expense_path(id: expense.id))

      expect(page).to have_selector('h1', text: 'Editar Despesa')
      expect(find(id: 'expense_description').value).to eq('Book')
      expect(find(id: 'expense_amount').value).to eq('R$ 21,50')
      expect(find(id: 'expense_date').value).to eq('2020-02-15')
      expect(find(id: 'expense_fixed')).not_to be_checked
      expect(find(id: 'expense_category').value).to eq('Alimentação')
      expect(find(id: 'expense_place_id').value).to eq(expense.place_id.to_s)
      expect(find(id: 'expense_expense_group_id').value).to eq(expense.expense_group_id.to_s)
      expect(find(id: 'expense_remark').value).to eq('')
      expect(page).to have_selector(:link_or_button, 'Salvar')
    end

    scenario 'user edits a expense' do
      visit(expense_path(id: expense.id))

      fill_in('Descrição', with: 'Book 1984')
      fill_in('Valor', with: '16.99')
      fill_in('Data da Compra', with: I18n.l(Date.parse('Feb 22 2020'), format: '%Y-%m-%d'))
      find('#expense_fixed').set(true)
      find('#expense_category').select('Saúde')
      find('#expense_place_id').select('Surubim')
      find('#expense_expense_group_id').select('Casa')
      fill_in('Observações', with: 'Money')

      find('input[name="commit"]').click

      expense.reload
      expect(expense.description).to eq('Book 1984')
      expect(expense.amount).to eq(16.99)
      expect(expense.date).to eq(Date.parse('Feb 22 2020'))
      expect(expense.fixed).to be_truthy
      expect(expense.category).to eq('health')
      expect(expense.place.name).to eq('Surubim')
      expect(expense.expense_group.name).to eq('Casa')
      expect(expense.remark).to eq('Money')

      expect(page).to have_content('Despesa atualizada.')
      expect(page).to have_selector('h1', text: 'Despesas - Fev/2020')
      expect(find(:xpath, '/html/body/main/div[3]/div/table/tbody/tr/td[1]').text).to eq('Book 1984')
      expect(find(:xpath, '/html/body/main/div[3]/div/table/tbody/tr/td[2]').text).to eq('16,99 R$')
      expect(find(:xpath, '/html/body/main/div[3]/div/table/tbody/tr/td[3]').text).to eq('22/02/2020')
      expect(find(:xpath, '/html/body/main/div[3]/div/table/tbody/tr/td[4]').text).to eq('Sim')
      expect(find(:xpath, '/html/body/main/div[3]/div/table/tbody/tr/td[5]').text).to eq('Saúde')
      expect(find(:xpath, '/html/body/main/div[3]/div/table/tbody/tr/td[6]').text).to eq('Surubim')
      expect(find(:xpath, '/html/body/main/div[3]/div/table/tbody/tr/td[7]').text).to eq('Casa')
      expect(find(:xpath, '/html/body/main/div[3]/div/table/tbody/tr/td[8]').text).to eq('Money')

      expect(page).to have_selector('h3', text: 'Total de Despesas: 16,99 R$')
    end

    scenario 'user edits a expense of other month' do
      visit(expense_path(id: expense_other_month.id, expense_month: '2020-03-31'))

      fill_in('Descrição', with: 'Book 1984')
      find('input[name="commit"]').click

      expense_other_month.reload
      expect(expense_other_month.description).to eq('Book 1984')

      expect(page).to have_content('Despesa atualizada.')
      expect(page).to have_selector('h1', text: 'Despesas - Mar/2020')
      expect(find(:xpath, '/html/body/main/div[3]/div/table/tbody/tr/td[1]').text).to eq('Book 1984')
    end
  end
end

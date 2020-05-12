# frozen_string_literal: true

require 'rails_helper'

feature 'ExpenseCategory', type: :feature do
  let!(:user) { create(:user) }

  before { login_as(user) }

  feature 'list expense_category' do
    context 'with one expense_category' do
      let(:expense_category) { ExpenseCategory.first }

      before { visit(expense_categories_path) }

      scenario 'user visits expense_categories page' do
        expect(find(:xpath, '/html/body/main/section/div[2]/div/table/thead/tr/th[1]').text).to eq('Nome')
        expect(find(:xpath, '/html/body/main/section/div[2]/div/table/thead/tr/th[2]').text).to eq('Descrição')
        expect(find(:xpath, '/html/body/main/section/div[2]/div/table/tbody/tr[1]/td[1]').text).to eq(expense_category.name)
        expect(find(:xpath, '/html/body/main/section/div[2]/div/table/tbody/tr[1]/td[2]').text).to be_blank
        expect(find(:xpath, '/html/body/main/section/div[2]/div/table/tbody/tr[1]/td[3]').text).to eq('Editar')
        expect(find(:xpath, '/html/body/main/section/div[2]/div/table/tbody/tr[1]/td[4]').text).to eq('Remover')
      end
    end
  end
end

# frozen_string_literal: true

require 'rails_helper'

feature 'ExpenseCategory', type: :feature do
  let!(:user) { create(:user) }
  let!(:expense_category) { create(:expense_category) }

  feature 'destroy expense' do
    before do
      login_as(user)
      visit(expense_categories_path)
    end

    scenario 'user visits expense_categories page and click to remove expense' do
      expect do
        find("a[href=\"/expense_categories/#{expense_category.id}\"]", text: 'Remove').click
      end.to change(ExpenseCategory, :count).by(-1)

      expect(page).to have_content('Categoria de Despesa removida.')
    end
  end
end

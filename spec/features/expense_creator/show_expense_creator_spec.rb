# frozen_string_literal: true

require 'rails_helper'

feature 'ExpenseCreator', type: :feature do
  let!(:user) { create(:user) }

  before { login_as(user) }

  feature 'show expense_creator_results' do
    let(:table_xpath) { '/html/body/main/section/div/div[1]/table/tbody/' }
    let(:expense_creator) { create(:expense_creator) }
    let(:expense_creator_results) { expense_creator.expense_creator_results.first }

    context 'with one expense_creator_result' do
      before { visit(expense_creator_path(expense_creator)) }

      scenario 'user visits expense_creator_results page' do
        expect(page).to have_selector('h1', text: 'Resultados')
        expect(page).to have_selector('th', text: 'Linha')
        expect(page).to have_selector('th', text: 'Resultado')
        expect(find(:xpath, "#{table_xpath}tr[1]/td[1]").text).to eq(expense_creator_results.raw_content)
        expect(find(:xpath, "#{table_xpath}tr[1]/td[2]").text).to eq(expense_creator_results.details)
        expect(page).to have_selector('h3', text: 'Total: 1')
      end
    end

    context 'with two expense_creator_results' do
      let!(:expense_creator_result_error) { create(:expense_creator_result_error, expense_creator: expense_creator) }

      before { visit(expense_creator_path(expense_creator)) }

      scenario 'user visits expense_creator_result page' do
        expect(page).to have_selector('h1', text: 'Resultados')
        expect(page).to have_selector('th', text: 'Linha')
        expect(page).to have_selector('th', text: 'Resultado')
        expect(find(:xpath, "#{table_xpath}tr[1]/td[1]").text).to eq(expense_creator_results.raw_content)
        expect(find(:xpath, "#{table_xpath}tr[1]/td[2]").text).to eq(expense_creator_results.details)
        expect(find(:xpath, "#{table_xpath}tr[2]/td[1]").text).to eq(expense_creator_result_error.raw_content)
        expect(find(:xpath, "#{table_xpath}tr[2]/td[2]").text).to eq(expense_creator_result_error.details)
        expect(page).to have_selector('h3', text: 'Total: 2')
      end
    end

    context 'with many expense_creator_results' do
      before do
        20.times.each { create(:expense_creator_result, expense_creator: expense_creator) }

        visit(expense_creator_path(expense_creator))
      end

      scenario 'user visits expense_creator_result page' do
        expect(page).to have_selector(:link_or_button, '1')
        expect(page).to have_selector(:link_or_button, '2')
        expect(page).to have_selector(:link_or_button, '›')
        expect(page).to have_selector(:link_or_button, '»')
        expect(page).not_to have_selector(:link_or_button, '3')

        expect(find(:xpath, '/html/body/main/section/div/div[1]/table/tbody/tr[20]')).to be_present
      end

      scenario 'user visits second expense_creator_result page' do
        click_on('2')
        expect(page).to have_selector(:link_or_button, '‹')
        expect(page).to have_selector(:link_or_button, '«')
        expect(page).to have_selector(:link_or_button, '1')
        expect(page).to have_selector(:link_or_button, '2')
        expect(page).not_to have_selector(:link_or_button, '3')
        expect(find(:xpath, '/html/body/main/section/div/div[1]/table/tbody/tr')).to be_present
      end
    end
  end
end

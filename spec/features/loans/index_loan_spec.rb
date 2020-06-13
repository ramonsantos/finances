# frozen_string_literal: true

require 'rails_helper'

feature 'Loans', type: :feature do
  let!(:user) { create(:user) }

  before { login_as(user) }

  feature 'list loan' do
    context 'without loans' do
      before { visit(loans_path) }

      scenario 'user visits loans page' do
        expect(page).to have_selector('h1', text: 'Empréstimos em Aberto')

        expect(page).to have_selector('th', text: 'Pessoa')
        expect(page).to have_selector('th', text: 'Descrição')
        expect(page).to have_selector('th', text: 'Valor')
        expect(page).to have_selector('th', text: 'Data')
        expect(page).to have_selector('th', text: 'Valor Recebido')
        expect(page).to have_selector('th', text: 'Recebido em')

        expect(page).not_to have_selector(:link_or_button, '1')
        expect(find(:xpath, '/html/body/main/section/div[3]/h3').text).to eq('Total em Empréstimos a Receber: 0,00 R$')
      end
    end

    context 'with one loan' do
      context 'when loan to receive ' do
        let!(:loan) { create(:loan) }

        before { visit(loans_path) }

        scenario 'user visits loans page' do
          expect(find(:xpath, '/html/body/main/section/div[2]/div/table/tbody/tr/td[1]').text).to eq(loan.person)
          expect(find(:xpath, '/html/body/main/section/div[2]/div/table/tbody/tr/td[2]').text).to eq(loan.description)
          expect(find(:xpath, '/html/body/main/section/div[2]/div/table/tbody/tr/td[3]').text).to eq('100,50 R$')
          expect(find(:xpath, '/html/body/main/section/div[2]/div/table/tbody/tr/td[4]').text).to eq('06/03/2020')
          expect(find(:xpath, '/html/body/main/section/div[2]/div/table/tbody/tr/td[5]').text).to be_blank
          expect(find(:xpath, '/html/body/main/section/div[2]/div/table/tbody/tr/td[6]').text).to be_blank

          expect(find(:xpath, '/html/body/main/section/div[3]/h3').text).to eq('Total em Empréstimos a Receber: 100,50 R$')
        end
      end

      context 'when received loans' do
        let!(:loan) { create(:loan, received_at: Date.parse('2020-04-15'), received_amount: 110.42) }

        before do
          create(:loan, borrowed_amount: 52.62)
          visit(loans_path({ loan_status: :received }))
        end

        scenario 'user visits loans page' do
          expect(find(:xpath, '/html/body/main/section/div[2]/div/table/tbody/tr/td[1]').text).to eq(loan.person)
          expect(find(:xpath, '/html/body/main/section/div[2]/div/table/tbody/tr/td[2]').text).to eq(loan.description)
          expect(find(:xpath, '/html/body/main/section/div[2]/div/table/tbody/tr/td[3]').text).to eq('100,50 R$')
          expect(find(:xpath, '/html/body/main/section/div[2]/div/table/tbody/tr/td[4]').text).to eq('06/03/2020')
          expect(find(:xpath, '/html/body/main/section/div[2]/div/table/tbody/tr/td[5]').text).to eq('110,42 R$')
          expect(find(:xpath, '/html/body/main/section/div[2]/div/table/tbody/tr/td[6]').text).to eq('15/04/2020')

          expect(find(:xpath, '/html/body/main/section/div[3]/h3').text).to eq('Total em Empréstimos a Receber: 52,62 R$')
        end
      end
    end

    context 'when loan page has pagination' do
      before do
        21.times.each { create(:loan) }

        visit(loans_path)
      end

      scenario 'user visits loans page' do
        expect(page).to have_selector(:link_or_button, '1')
        expect(page).to have_selector(:link_or_button, '2')
        expect(page).to have_selector(:link_or_button, '›')
        expect(page).to have_selector(:link_or_button, '»')
        expect(page).not_to have_selector(:link_or_button, '3')

        expect(find(:xpath, '/html/body/main/section/div[2]/div/table/tbody/tr[20]')).to be_present
        expect(find(:xpath, '/html/body/main/section/div[3]/h3').text).to eq('Total em Empréstimos a Receber: 2.110,50 R$')
      end

      scenario 'user visits second loans page' do
        click_on('2')
        expect(page).to have_selector(:link_or_button, '‹')
        expect(page).to have_selector(:link_or_button, '«')
        expect(page).to have_selector(:link_or_button, '1')
        expect(page).to have_selector(:link_or_button, '2')
        expect(page).not_to have_selector(:link_or_button, '3')

        expect(find(:xpath, '/html/body/main/section/div[2]/div/table/tbody/tr')).to be_present
        expect(find(:xpath, '/html/body/main/section/div[3]/h3').text).to eq('Total em Empréstimos a Receber: 2.110,50 R$')
      end
    end
  end
end

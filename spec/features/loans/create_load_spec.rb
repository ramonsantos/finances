# frozen_string_literal: true

require 'rails_helper'

feature 'Loan', type: :feature do
  let!(:user) { create(:user) }

  feature 'create loan' do
    before do
      login_as(user)
      visit(new_loan_path)
    end

    scenario 'user visits new loan page' do
      expect(page).to have_selector('h1', text: 'Adicionar Empréstimo')
      expect(page).to have_selector('input', id: 'loan_person')
      expect(page).to have_selector('input', id: 'loan_description')
      expect(page).to have_selector('input', id: 'loan_borrowed_amount')
      expect(page).to have_selector('input', id: 'loan_loan_date')
      expect(page).to have_selector('input', id: 'loan_expected_amount_to_receive')
      expect(page).to have_selector('input', id: 'loan_estimated_receipt_at')
      expect(page).to have_selector('input', id: 'loan_received_amount')
      expect(page).to have_selector('input', id: 'loan_received_at')
      expect(page).to have_selector(:link_or_button, 'Salvar')
    end

    feature 'user creates a loan' do
      let(:loan) { Loan.where(user: user).last }

      before do
        fill_in('Pessoa',                     with: 'Maria')
        fill_in('Descrição',                  with: 'Comprar Livro')
        fill_in('Valor do Emprétimo',         with: '14.99')
        fill_in('Valor Esperado Receber',     with: '15.99')
        fill_in('Data do Empréstimo',         with: I18n.l(Date.parse('Feb 21 2020'), format: '%Y-%m-%d'))
        fill_in('Data Estimada para Receber', with: I18n.l(Date.parse('Mar 21 2020'), format: '%Y-%m-%d'))
      end

      scenario 'creates loan' do
        expect { find('input[name="commit"]').click }.to change(Loan, :count).by(1)

        expect(loan.person).to eq('Maria')
        expect(loan.description).to eq('Comprar Livro')
        expect(loan.borrowed_amount).to eq(14.99)
        expect(loan.loan_date).to eq(Date.parse('Feb 21 2020'))
        expect(loan.estimated_receipt_at).to eq(Date.parse('Mar 21 2020'))
        expect(loan.expected_amount_to_receive).to eq(15.99)
        expect(loan.received_amount).to be_blank
        expect(loan.received_at).to be_blank
        expect(page).to have_content('Empréstimo adicionado.')
      end

      scenario 'creates loan with "received_amount"' do
        fill_in('Valor Recebido', with: '15.40')

        expect { find('input[name="commit"]').click }.to change(Loan, :count).by(1)

        expect(loan.person).to eq('Maria')
        expect(loan.description).to eq('Comprar Livro')
        expect(loan.borrowed_amount).to eq(14.99)
        expect(loan.loan_date).to eq(Date.parse('Feb 21 2020'))
        expect(loan.estimated_receipt_at).to eq(Date.parse('Mar 21 2020'))
        expect(loan.expected_amount_to_receive).to eq(15.99)
        expect(loan.received_amount).to eq(15.4)
        expect(loan.received_at).to eq(Time.zone.today)
        expect(page).to have_content('Empréstimo adicionado.')
      end
    end
  end
end

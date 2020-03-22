# frozen_string_literal: true

require 'rails_helper'

feature 'Loans', type: :feature do
  let!(:user) { create(:user) }
  let!(:loan) { create(:loan) }

  before do
    login_as(user)
    visit(loan_path(id: loan.id))
  end

  feature 'show and edit loan' do
    scenario 'user visits loan page' do
      expect(page).to have_selector('h1', text: 'Editar Empréstimo')
      expect(find(id: 'loan_person').value).to eq('Maria')
      expect(find(id: 'loan_description').value).to eq('Comprar Telefone')
      expect(find(id: 'loan_loan_date').value).to eq('2020-03-06')
      expect(find(id: 'loan_borrowed_amount').value).to eq('R$ 100,50')
      expect(find(id: 'loan_expected_amount_to_receive').value).to eq('R$ 110,00')
      expect(find(id: 'loan_estimated_receipt_at').value).to eq('2020-04-06')
      expect(find(id: 'loan_received_amount').value).to be_blank
      expect(find(id: 'loan_received_at').value).to eq(Time.zone.today.to_s)
      expect(page).to have_selector(:link_or_button, 'Salvar')
    end

    scenario 'user edits a loan' do
      fill_in('Pessoa', with: 'João')
      fill_in('Descrição', with: 'Pagar Luz')
      fill_in('Valor do Empréstimo', with: 200.6)
      fill_in('Data do Empréstimo', with: I18n.l(Date.parse('Mar 21 2020'), format: '%Y-%m-%d'))
      fill_in('Valor Esperado Receber', with: 210.99)
      fill_in('Data Estimada para Receber', with: I18n.l(Date.parse('May 21 2020'), format: '%Y-%m-%d'))
      fill_in('Valor Recebido', with: 209.0)
      fill_in('Recebido em', with: I18n.l(Date.parse('May 09 2020'), format: '%Y-%m-%d'))
      find('input[name="commit"]').click

      loan.reload
      expect(loan.person).to eq('João')
      expect(loan.description).to eq('Pagar Luz')
      expect(loan.loan_date).to eq(Date.parse('Mar 21 2020'))
      expect(loan.borrowed_amount).to eq(200.6)
      expect(loan.expected_amount_to_receive).to eq(210.99)
      expect(loan.estimated_receipt_at).to eq(Date.parse('May 21 2020'))
      expect(loan.received_amount).to eq(209.0)
      expect(loan.received_at).to eq(Date.parse('May 09 2020'))
      expect(page).to have_content('Empréstimo atualizado.')
    end
  end
end

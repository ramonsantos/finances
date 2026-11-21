# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Loans", type: :system do
  it "marks a loan as received" do
    Timecop.freeze(Date.new(2025, 3, 1)) do
      loan = create(:loan, borrowed_amount: 200)

      visit loan_path(loan)
      fill_in "Valor emprestado", with: "200.00"
      fill_in "Valor recebido", with: "200.00"
      click_button "Salvar"

      expect(page).to have_content("Empréstimo atualizado")
      expect(loan.reload.received_at).to eq(Date.new(2025, 3, 1))
    end
  end
end
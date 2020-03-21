# frozen_string_literal: true

require 'rails_helper'

feature 'Loans', type: :feature do
  let!(:user) { create(:user) }
  let!(:loan) { create(:loan) }

  feature 'destroy expense' do
    before do
      login_as(user)
      visit(loans_path)
    end

    scenario 'user visits loans page and click to remove expense' do
      expect do
        find("a[href=\"/loans/#{loan.id}\"]", text: 'Remove').click
      end.to change(Loan, :count).by(-1)

      expect(page).to have_content('Empréstimo removido.')
    end
  end
end

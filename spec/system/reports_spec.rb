# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Expense report", type: :system do
  it "displays totals per group" do
    category = create(:expense_category, name: "Alimentação")
    group = create(:expense_group, name: "Pessoal")
    create(:expense, amount: 50, expense_category: category, expense_group: group, date: Time.zone.today)
    create(:expense, amount: 50, expense_category: category, expense_group: group, date: Time.zone.today)

    visit report_expenses_path

    expect(page).to have_content("Pessoal")
    expect(page).to have_content("R$ 100,00")
  end
end
# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Expenses", type: :system do
  let!(:category) { create(:expense_category, name: "Alimentação") }
  let!(:group) { create(:expense_group, name: "Pessoal") }

  it "lists monthly expenses and creates a new one" do
    create(:expense, description: "Padaria", amount: 15, date: Time.zone.today, expense_category: category, expense_group: group)

    visit expenses_path

    expect(page).to have_content("Padaria")
    expect(page).to have_content("R$")

    visit new_expense_path
    fill_in "Descrição", with: "Feira"
    fill_in "Valor", with: "30.00"
    fill_in "Data", with: Time.zone.today.to_s
    select "Alimentação", from: "Categoria"
    select "Pessoal", from: "Grupo"
    click_button "Salvar"

    expect(page).to have_content("Despesa adicionada")
    expect(page).to have_content("Feira")
  end
end
# frozen_string_literal: true

FactoryBot.define do
  factory :expense_category do
    sequence(:name) { |n| "Categoria #{n}" }
    description { "Descrição" }
  end
end
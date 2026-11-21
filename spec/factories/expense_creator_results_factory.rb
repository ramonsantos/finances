# frozen_string_literal: true

FactoryBot.define do
  factory :expense_creator_result do
    expense_creator { nil }
    raw_content { { date: '01/01/2025', description: 'Mercado', amount: '10,00' }.to_json }
    success { false }
    details { 'MyString' }
  end
end

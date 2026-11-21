# frozen_string_literal: true

FactoryBot.define do
  factory :expense do
    description { 'Compra' }
    amount { 25.50 }
    date { Time.zone.today }
    fixed { false }
    expense_category
    expense_group
  end
end

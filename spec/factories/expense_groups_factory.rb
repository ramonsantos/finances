# frozen_string_literal: true

FactoryBot.define do
  factory :expense_group do
    sequence(:name) { |n| "Grupo #{n}" }
  end
end

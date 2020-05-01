# frozen_string_literal: true

FactoryBot.define do
  factory :expense_category do
    user { User.first || create(:user) }

    name { 'Saúde' }
    description { '' }
  end
end

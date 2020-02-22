# frozen_string_literal: true

FactoryBot.define do
  factory :expense_group do
    user { User.first || create(:user) }

    name { 'Trabalho' }

    trait :expense_group_home do
      name { 'Casa' }
    end

    factory :expense_group_home, traits: [:expense_group_home]
  end
end

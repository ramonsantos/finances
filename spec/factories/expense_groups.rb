# frozen_string_literal: true

FactoryBot.define do
  factory :expense_group do
    user { User.first || create(:user) }

    name { 'Work' }
  end
end

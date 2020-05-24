# frozen_string_literal: true

FactoryBot.define do
  factory :expense_creator do
    user { User.first || create(:user) }

    date { '2020-05-22 18:08:10' }

    after(:create) do |expense_creator|
      create(:expense_creator_result, expense_creator: expense_creator)
    end
  end
end

# frozen_string_literal: true

FactoryBot.define do
  factory :expense_creator do
    user { User.first || create(:user) }

    date { '2020-05-22 18:08:10' }
  end
end

# frozen_string_literal: true

FactoryBot.define do
  factory :expense do
    user { User.first || create(:user) }
    place { Place.first || create(:place) }
    expense_group { ExpenseGroup.first || create(:expense_group) }

    description { 'Book' }
    amount { 21.5 }
    date { '2020-02-15' }
    fixed { false }
    remark { '' }

    category { 'food' }
  end
end

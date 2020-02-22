# frozen_string_literal: true

FactoryBot.define do
  factory :expense do
    user { User.first || create(:user) }
    place_id { Place.first.try(:id) || create(:place).id }
    expense_group_id { ExpenseGroup.first.try(:id) || create(:expense_group).id }

    description { 'Book' }
    amount { 21.5 }
    date { '2020-02-15' }
    fixed { false }
    remark { '' }

    category { 'food' }
  end
end

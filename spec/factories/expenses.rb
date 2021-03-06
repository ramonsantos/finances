# frozen_string_literal: true

FactoryBot.define do
  factory :expense do
    user { User.first || create(:user) }
    place_id { Place.first.try(:id) || create(:place).id }
    expense_group_id { ExpenseGroup.first.try(:id) || create(:expense_group).id }
    expense_category_id { ExpenseCategory.first.try(:id) || create(:expense_category).id }

    description { 'Book' }
    amount { 21.5 }
    date { '2020-02-15' }
    fixed { false }
    remark { '' }

    trait :expense_other_month do
      amount { 11.5 }
      date { '2020-03-01' }
    end

    factory :expense_other_month, traits: [:expense_other_month]
  end
end

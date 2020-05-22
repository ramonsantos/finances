# frozen_string_literal: true

FactoryBot.define do
  factory :expense_creator_result do
    expense_creator { ExpenseCreator.first || create(:expense_creator) }

    raw_content { "MyText" }
    success { false }
    details { "MyString" }
  end
end

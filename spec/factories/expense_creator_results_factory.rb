# frozen_string_literal: true

FactoryBot.define do
  factory :expense_creator_result do
    expense_creator { nil }
    raw_content { 'MyText' }
    success { false }
    details { 'MyString' }
  end
end

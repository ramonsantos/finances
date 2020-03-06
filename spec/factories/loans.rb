# frozen_string_literal: true

FactoryBot.define do
  factory :loan do
    description { 'MyString' }
    loan_date { '2020-03-06' }
    estimated_receipt_at { '2020-03-06' }
    received_at { '2020-03-06' }
    borrowed_amount { 1.5 }
    expected_amount_to_receive { 1.5 }
    person { 'MyString' }
    gain { 1.5 }
  end
end

# frozen_string_literal: true

FactoryBot.define do
  factory :payment_method do
    sequence(:name) { |n| "Forma #{n}" }
  end
end

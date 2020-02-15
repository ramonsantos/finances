# frozen_string_literal: true

FactoryBot.define do
  factory :expense do
    description { 'Book' }
    amount { 21.5 }
    date { '2020-02-15' }
    fixed { false }
    remark { '' }

    category { 'food' }
  end
end

# frozen_string_literal: true

FactoryBot.define do
  factory :loan do
    user { User.first || create(:user) }

    person { 'Maria' }
    description { 'Comprar Telefone' }
    loan_date { '2020-03-06' }
    borrowed_amount { 100.5 }
    received_at {}
    received_amount {}
  end
end

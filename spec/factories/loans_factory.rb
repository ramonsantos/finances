# frozen_string_literal: true

FactoryBot.define do
  factory :loan do
    person { 'João' }
    description { 'Empréstimo pessoal' }
    borrowed_amount { 100.0 }
    loan_date { Time.zone.today }
  end
end

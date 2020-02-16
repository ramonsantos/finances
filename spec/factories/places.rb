# frozen_string_literal: true

FactoryBot.define do
  factory :place do
    user { User.first || create(:user) }

    name { 'Recife' }
  end
end

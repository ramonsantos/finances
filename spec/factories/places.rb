# frozen_string_literal: true

FactoryBot.define do
  factory :place do
    user { User.first || create(:user) }

    name { 'Recife' }

    trait :place_surubim do
      name { 'Surubim' }
    end

    factory :place_surubim, traits: [:place_surubim]
  end
end

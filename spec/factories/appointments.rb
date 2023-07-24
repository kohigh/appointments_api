# frozen_string_literal: true

FactoryBot.define do
  factory :appointment do
    association :dentist, factory: :user
    association :patient, factory: :user
    day { Faker::Date.between(from: '2021-01-04', to: '2021-01-07') }
    slot { Faker::Number.between(from: 1, to: 20) }
  end
end

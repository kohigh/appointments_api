# frozen_string_literal: true

FactoryBot.define do
  factory :appointment do
    association :dentist, factory: :user
    association :patient, factory: :user
    day { Faker::Date.rand }
    slot { Faker::Number.between(from: 1, to: 18) }
  end
end

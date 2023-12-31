# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "#{n}_#{Faker::Internet.email}" }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    token { SecureRandom.urlsafe_base64 }
  end
end
# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "test-#{n}@example.com" }
    password { SecureRandom.base58(24) }
  end
end

FactoryBot.define do
  factory :device do
    sequence(:name) { |n| "device_#{n}" }
    timezone { "Africa/Accra" }
    identity { SecureRandom.base58(24) }

    association :user, factory: :user
  end
end

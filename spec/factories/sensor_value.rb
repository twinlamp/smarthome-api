FactoryBot.define do
  factory :sensor_value do
    value { (rand * 100).to_i }
    sequence(:registered_at) { |n| DateTime.now - n.minutes }

    association :sensor, factory: :sensor
  end
end

FactoryBot.define do
  factory :sensor do
    sequence(:name) { |n| "sensor_#{n}" }
    sequence(:conf_name) { |n| "sensor_#{n}" }
    icon { 'humidity' }
    sequence(:order) { |n| n }
    min { 0 }
    max { 100 }

    association :device, factory: :device
  end
end

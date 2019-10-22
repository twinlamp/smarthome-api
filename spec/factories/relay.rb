FactoryBot.define do
  factory :relay do
    sequence(:name) { |n| "sensor_#{n}" }
    sequence(:conf_name) { |n| "sensor_#{n}" }
    icon { 'boiler' }
    sequence(:order) { |n| n }
    value { false }
    state { %w[on off task_mode].sample }

    association :device, factory: :device
  end
end

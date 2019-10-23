# frozen_string_literal: true

FactoryBot.define do
  factory :task do
    min { 0 }
    max { 100 }

    association :relay, factory: :relay
  end
end

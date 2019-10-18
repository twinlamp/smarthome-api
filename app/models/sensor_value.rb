class SensorValue < ApplicationRecord
  belongs_to :sensor

  delegate :device, to: :sensor
end

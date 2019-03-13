class SensorValue < ApplicationRecord
  belongs_to :sensor

  validates_presence_of :value, :registered_at
  validates_uniqueness_of :registered_at
end

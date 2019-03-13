class Sensor < ApplicationRecord
  belongs_to :device
  has_one :relay
  has_many :values, class_name: 'SensorValue'

  validates_presence_of :name, :icon, :min, :max
  validates_uniqueness_of :name, scope: :device_id
end

class Sensor < ApplicationRecord
  belongs_to :device
  has_one :relay
  has_many :values, class_name: 'SensorValue'
end

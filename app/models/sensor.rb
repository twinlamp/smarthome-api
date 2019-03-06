class Sensor < ApplicationRecord
  belongs_to :device

  validates_presence_of :name, :icon, :min, :max
  validates_uniqueness_of :name, scope: :device_id
end

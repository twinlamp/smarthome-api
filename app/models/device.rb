# frozen_string_literal: true

class Device < ApplicationRecord
  belongs_to :user
  has_many :sensors
  has_many :free_sensors, -> { left_outer_joins(:relay).where(relays: { sensor_id: nil }) }, class_name: 'Sensor'
  has_many :relays

  def device
    self
  end
end

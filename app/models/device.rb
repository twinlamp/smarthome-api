class Device < ApplicationRecord
  belongs_to :user
  has_many :sensors
  has_many :free_sensors, -> { left_outer_joins(:relay).where(relays: { sensor_id: nil }) }, class_name: 'Sensor'
  has_many :relays

  before_validation :set_identity, on: :create

  validates_presence_of :name, :timezone, :identity
  validates_uniqueness_of :name, scope: :user_id

  private

  def set_identity
    self.identity = SecureRandom.base58(24)
  end
end

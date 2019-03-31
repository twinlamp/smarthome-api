class Relay < ApplicationRecord
  belongs_to :device
  belongs_to :sensor, optional: true
  has_one :task

  enum state: %i(off on task_mode)

  validates_presence_of :name, :icon
  validates_uniqueness_of :name, scope: :device_id
end

class Relay < ApplicationRecord
  belongs_to :device
  belongs_to :sensor, optional: true
  has_one :task

  enum state: %i(off on task_mode)
end

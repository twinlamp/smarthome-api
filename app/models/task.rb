# frozen_string_literal: true

class Task < ApplicationRecord
  belongs_to :relay
  belongs_to :sensor, optional: true
  has_one :task_schedule

  delegate :device, to: :relay
end

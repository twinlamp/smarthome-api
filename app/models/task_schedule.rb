# frozen_string_literal: true

class TaskSchedule < ApplicationRecord
  belongs_to :task

  delegate :device, to: :task
end

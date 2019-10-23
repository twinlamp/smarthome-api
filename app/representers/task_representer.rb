# frozen_string_literal: true

class TaskRepresenter < Representable::Decorator
  include Representable::JSON
  defaults render_nil: true

  property :id
  property :sensor_id
  property :min, exec_context: :decorator
  property :max, exec_context: :decorator
  property :task_schedule, exec_context: :decorator, decorator: TaskScheduleRepresenter

  def task_schedule
    represented.task_schedule || represented.build_task_schedule
  end

  def min
    represented.min.nil? ? nil : represented.min.to_i
  end

  def max
    represented.max.nil? ? nil : represented.max.to_i
  end
end

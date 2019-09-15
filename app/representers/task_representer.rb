class TaskRepresenter < Representable::Decorator
  include Representable::JSON
  defaults render_nil: true

  property :id
  property :sensor_id
  property :min
  property :max
  property :task_schedule, exec_context: :decorator, decorator: TaskScheduleRepresenter

  def task_schedule
    represented.task_schedule || represented.build_task_schedule
  end
end

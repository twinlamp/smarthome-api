class TaskScheduleRepresenter < Representable::Decorator
  include Representable::JSON
  defaults render_nil: true

  property :id
  property :task_id
  property :start
  property :stop
  property :days
end

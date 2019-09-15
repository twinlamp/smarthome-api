class RelayRepresenter < Representable::Decorator
  include Representable::JSON
  defaults render_nil: true

  property :id
  property :icon
  property :title, exec_context: :decorator
  property :name
  property :sensor, decorator: SensorRepresenter
  property :task, exec_context: :decorator, decorator: TaskRepresenter
  property :value
  property :state
  property :device_id
  collection :possible_sensors, exec_context: :decorator, decorator: SensorRepresenter, if: -> (user_options:, **) { user_options.try(:[], :with_possible_sensors) }

  def title
    represented.name || represented.conf_name || represented.order
  end

  def possible_sensors
    ary = [represented.sensor]
    ary += represented.device.free_sensors
    ary
  end

  def task
    represented.task || represented.build_task
  end
end

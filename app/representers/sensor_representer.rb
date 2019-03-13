class SensorRepresenter < Representable::Decorator
  include Representable::JSON
  defaults render_nil: true

  property :id
  property :icon
  property :title, exec_context: :decorator
  property :name
  property :min
  property :max
  property :value, exec_context: :decorator
  property :device_id

  collection :values, class: SensorValue, decorator: SensorValueRepresenter, if: -> (user_options:, **) { user_options.try(:[], :with_values) }

  def title
    represented.name || represented.conf_name || represented.order
  end

  def value
    represented.value.to_i
  end
end

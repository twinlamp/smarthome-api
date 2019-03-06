class DeviceRepresenter < Representable::Decorator
  include Representable::JSON
  defaults render_nil: true

  property :id
  property :name
  property :timezone
  property :identity

  collection :sensors, class: Sensor, decorator: SensorRepresenter, if: -> (user_options:, **) { user_options.try(:[], :with_children) }
end

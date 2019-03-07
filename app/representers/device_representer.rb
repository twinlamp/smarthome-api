class DeviceRepresenter < Representable::Decorator
  include Representable::JSON
  defaults render_nil: true

  property :id
  property :name
  property :timezone
  property :identity

  collection :free_sensors, class: Sensor, decorator: SensorRepresenter, if: -> (user_options:, **) { user_options.try(:[], :with_children) }
  collection :relays, class: Relay, decorator: RelayRepresenter, if: -> (user_options:, **) { user_options.try(:[], :with_children) }
end

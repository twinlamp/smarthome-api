class DeviceRepresenter < Representable::Decorator
  include Representable::JSON
  defaults render_nil: true

  property :id
  property :title, exec_context: :decorator
  property :name
  property :timezone
  property :identity

  collection :free_sensors, class: Sensor, decorator: SensorRepresenter, if: -> (user_options:, **) { user_options.try(:[], :with_children) }
  collection :relays, class: Relay, decorator: RelayRepresenter, if: -> (user_options:, **) { user_options.try(:[], :with_children) }

  def title
    represented.name
  end
end

class SensorRepresenter < Representable::Decorator
  include Representable::JSON
  defaults render_nil: true

  property :id
  property :icon
  property :name
  property :min
  property :max
  property :value
  property :order
  property :conf_name

end

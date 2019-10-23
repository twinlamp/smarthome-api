# frozen_string_literal: true

class SensorValueRepresenter < Representable::Decorator
  include Representable::JSON
  defaults render_nil: true

  property :value
  property :registered_at
end

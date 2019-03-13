class RelayRepresenter < Representable::Decorator
  include Representable::JSON
  defaults render_nil: true

  property :id
  property :icon
  property :title, exec_context: :decorator
  property :name
  property :sensor, decorator: SensorRepresenter
  property :value
  property :state

  def title
    represented.name || represented.conf_name || represented.order
  end
end

# frozen_string_literal: true

class UserRepresenter < Representable::Decorator
  include Representable::JSON
  defaults render_nil: true

  property :id
  property :email
end

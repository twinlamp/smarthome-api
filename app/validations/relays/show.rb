module Validations
  module Relays
    class Show < Validator

      params do
        required(:id).filled(:integer)
      end
    end
  end
end
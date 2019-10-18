module Validations
  module Sensors
    class Show < Validator

      params do
        required(:id).filled(:integer)
      end
    end
  end
end
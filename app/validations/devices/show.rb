module Validations
  module Devices
    class Show < Validator

      params do
        required(:id).filled(:integer)
      end
    end
  end
end
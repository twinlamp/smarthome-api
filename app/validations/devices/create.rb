# frozen_string_literal: true

module Validations
  module Devices
    class Create < Validator
      params do
        required(:user_id).filled(:integer)
        required(:name).filled(:string)
        required(:timezone).filled(:string)
        required(:identity).filled(:string)
      end

      rule(:name) do
        key.failure('must be unique') unless Device.where(name: value, user_id: values.data.dig(:user_id)).none?
      end
    end
  end
end

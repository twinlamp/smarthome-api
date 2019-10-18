module Validations
  module Devices
    class Create < Validator

      params do
        required(:device).schema do
          required(:user_id).filled(:integer)
          required(:name).filled(:string)
          required(:timezone).filled(:string)
          required(:identity).filled(:string)
        end
      end

      rule(device: :name) do
        key.failure('name must be unique') unless Device.where(name: value, user_id: values.data.dig(:device, :user_id)).none?
      end
    end
  end
end
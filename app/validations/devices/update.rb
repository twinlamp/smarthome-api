# frozen_string_literal: true

module Validations
  module Devices
    class Update < Validator
      params do
        required(:id).filled(:integer)
        required(:device).schema do
          required(:user_id).filled(:integer)
          required(:name).filled(:string)
          required(:timezone).filled(:string)
        end
      end

      rule(device: :name) do
        other_devices = Device.where(name: value, user_id: values.data.dig(:device, :user_id)).where.not(id: values.data[:id])
        key.failure('name must be unique') unless other_devices.none?
      end
    end
  end
end

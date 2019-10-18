module Validations
  module Sensors
    class Update < Validator

      params do
        required(:id).filled(:integer)
        required(:sensor).schema do
          required(:name).filled(:string)
          required(:icon).filled(:string)
          required(:min).filled(:integer)
          required(:max).filled(:integer)
        end
      end

      rule(sensor: :min) do
        min = value
        max = values.data.dig(:sensor, :max)

        key.failure('min should be < max') unless min < max
      end

      rule(sensor: :name) do
        other_sensors = Sensor.where.not(id: values.data[:id]).where(name: value, device_id: Sensor.find_by(id: values.data[:id])&.device_id)        
        key.failure('name must be unique') unless other_sensors.none?
      end
    end
  end
end
module Transactions
  module Devices
    class Index
      include Dry::Transaction(container: SmarthomeApi::Container)

      check :policy, with: 'policies.authenticated_user'
      step :find_devices

      private

      def find_sensor(input)
        sensor = ::Sensor.find(input[:params][:sensor_id])
        Success(input.merge(model: sensor))
      end

      def find_devices(input)
        Success(input.merge(data: current_user&.devices))
      end
    end
  end
end

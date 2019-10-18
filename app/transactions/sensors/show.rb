module Transactions
  module Sensors
    class Show
      include Dry::Transaction(container: SmarthomeApi::Container)

      step :validate, with: 'validations.sensors.show'
      step :find_sensor
      check :policy, with: 'policies.device_owner'

      private

      def find_sensor(input)
        sensor = ::Sensor.find(input[:params][:id])
        Success(input.merge(model: sensor))
      end
    end
  end
end

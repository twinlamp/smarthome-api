module Transactions
  module Sensors
    class Update
      include Dry::Transaction(container: SmarthomeApi::Container)

      step :validate, with: 'validations.sensors.update'
      try :find_sensor, catch: ActiveRecord::RecordNotFound
      check :policy, with: 'policies.device_owner'
      step :update

      private

      def find_sensor(input)
        sensor = ::Sensor.find(input[:params][:id])
        input.merge(model: sensor)
      end

      def update(input)
        input[:model].update(input[:params][:sensor])
        Success(input)
      end
    end
  end
end

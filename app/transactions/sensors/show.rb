# frozen_string_literal: true

module Transactions
  module Sensors
    class Show
      include Dry::Transaction(container: SmarthomeApi::Container)

      step :validate, with: 'validations.sensors.show'
      try :find_sensor, catch: ActiveRecord::RecordNotFound
      check :policy, with: 'policies.device_owner'

      private

      def find_sensor(input)
        sensor = ::Sensor.find(input[:params][:id])
        input.merge(model: sensor)
      end
    end
  end
end

module Transactions
  module Devices
    class Show
      include Dry::Transaction(container: SmarthomeApi::Container)

      step :validate, with: 'validations.devices.show'
      step :find_device
      check :policy, with: 'policies.device_owner'

      private

      def find_device(input)
        device = ::Device.find(input[:params][:id])
        Success(input.merge(model: device))
      end
    end
  end
end

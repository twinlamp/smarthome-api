module Transactions
  module Devices
    class Create
      include Dry::Transaction(container: SmarthomeApi::Container)

      step :set_user_id
      step :set_identity
      step :validate, with: 'validations.devices.create'
      check :policy, with: 'policies.authenticated_user'
      step :create_device

      private

      def set_user_id(input)
        input[:params][:user_id] = input[:user].id
        Success(input)
      end

      def set_identity(input)
        input[:params][:identity] = SecureRandom.base58(24)
        Success(input)
      end

      def create_device(input)
        device = ::Device.create!(input[:params])
        Success(input.merge(model: device))
      end
    end
  end
end

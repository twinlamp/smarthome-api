module Transactions
  module Devices
    class Index
      include Dry::Transaction(container: SmarthomeApi::Container)

      check :policy, with: 'policies.authenticated_user'
      step :find_devices

      private

      def find_devices(input)
        Success(input.merge(data: input[:user].devices))
      end
    end
  end
end

module Transactions
  module Relays
    class Show
      include Dry::Transaction(container: SmarthomeApi::Container)

      step :validate, with: 'validations.relays.show'
      step :find_relay
      check :policy, with: 'policies.device_owner'

      private

      def find_relay(input)
        relay = ::Relay.find(input[:params][:id])
        Success(input.merge(model: relay))
      end
    end
  end
end

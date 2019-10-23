# frozen_string_literal: true

module Transactions
  module Relays
    class Show
      include Dry::Transaction(container: SmarthomeApi::Container)

      step :validate, with: 'validations.relays.show'
      try :find_relay, catch: ActiveRecord::RecordNotFound
      check :policy, with: 'policies.device_owner'

      private

      def find_relay(input)
        relay = ::Relay.find(input[:params][:id])
        input.merge(model: relay)
      end
    end
  end
end

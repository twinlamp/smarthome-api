# frozen_string_literal: true

module Transactions
  module Devices
    class Update
      include Dry::Transaction(container: SmarthomeApi::Container)

      step :set_user_id
      step :validate, with: 'validations.devices.update'
      try :find_device, catch: ActiveRecord::RecordNotFound
      check :policy, with: 'policies.device_owner'
      step :update

      private

      def set_user_id(input)
        input[:params][:device][:user_id] = input[:user].id
        Success(input)
      end

      def find_device(input)
        device = ::Device.find(input[:params][:id])
        input.merge(model: device)
      end

      def update(input)
        input[:model].update(input[:params][:device])
        Success(input)
      end
    end
  end
end

module Transactions
  module Relays
    class UpdateRelay
      include Dry::Transaction(container: SmarthomeApi::Container)

      step :validate, with: 'validations.relays.update'
      step :find_relay
      check :policy, with: 
      step :update

      private

      def find_relay(input)
        byebug
        relay = ::Relay.find(input.dig(:params, :id))
        Success(input.merge(model: relay))
      end

      def policy(input)
        input[:model].device.user == params[:user]
      end

      def update(input)
        ActiveRecord::Base.transaction do
          input[:model].update(input.dig(:params, :relay))

          return unless input.dig(:params, :relay, :task)
          input[:model].find_or_build_task.update(input.dig(:params, :relay, :task))

          return unless input.dig(:params, :relay, :task_schedule)
          input[:model].task.find_or_build_task_schedule.update(input.dig(:params, :relay, :task, :task_schedule))
        end
        Success(input)
      end
    end
  end
end

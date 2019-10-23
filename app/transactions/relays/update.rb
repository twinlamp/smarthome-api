# frozen_string_literal: true

module Transactions
  module Relays
    class Update
      include Dry::Transaction(container: SmarthomeApi::Container)

      step :validate, with: 'validations.relays.update'
      try :find_relay, catch: ActiveRecord::RecordNotFound
      check :policy, with: 'policies.device_owner'
      step :consider_values_range
      step :consider_schedule
      step :update

      private

      def find_relay(input)
        relay = ::Relay.find(input[:params][:id])
        input.merge(model: relay)
      end

      def consider_values_range(input)
        nullify_minmax(input) if input[:params][:relay][:task].to_h.key?(:values_range) && input[:params][:relay][:task][:values_range] == false

        Success(input)
      end

      def consider_schedule(input)
        return Success(input) unless input[:params][:relay].dig(:task, :task_schedule)

        case input[:params][:relay][:task][:task_schedule][:schedule]
        when 'calendar'
          nullify_weekly(input)
        when 'weekly'
          nullify_calendar(input)
        else
          nullify_weekly(input)
          nullify_calendar(input)
        end

        Success(input)
      end

      def update(input)
        ActiveRecord::Base.transaction do
          input[:model].update(input[:params][:relay].except(:task))

          next unless input[:params][:relay][:task]

          task = input[:model].task || input[:model].build_task
          task.update(input[:params][:relay][:task].except(:task_schedule, :values_range))

          next unless input[:params][:relay][:task][:task_schedule]

          task_schedule = task.task_schedule || task.build_task_schedule
          task_schedule.update(input[:params][:relay][:task][:task_schedule].except(:schedule))
        end
        Success(input)
      end

      def nullify_weekly(input)
        return unless input[:params][:relay][:task][:task_schedule][:days]

        input[:params][:relay][:task][:task_schedule][:days].keys.each do |day|
          input[:params][:relay][:task][:task_schedule][:days][day] = { on: nil, off: nil }
        end
      end

      def nullify_calendar(input)
        input[:params][:relay][:task][:task_schedule][:start] = nil
        input[:params][:relay][:task][:task_schedule][:stop] = nil
      end

      def nullify_minmax(input)
        input[:params][:relay][:task][:min] = nil
        input[:params][:relay][:task][:max] = nil
      end
    end
  end
end

module Validations
  module Relays
    class Update < Dry::Validation::Contract

      def call(input)
        result = super(input[:params].permit!.to_h)

        return Dry::Monads::Result::Failure.new(result.errors.to_h) if result.failure?
        Dry::Monads::Result::Success.new(input.merge(params: result.schema_result.output))
      end

      DAYS = %i[mon tue wed thu fri sat sun].freeze

      params do
        required(:id).filled(:integer)
        required(:relay).schema do
          required(:icon).filled(:string)
          required(:name).filled(:string)
          required(:state).filled(:string, included_in?: %w[off on task_mode])
          required(:sensor_id).filled(:integer)

          optional(:task).schema do
            required(:values_range).filled(:bool)

            optional(:min).maybe(:integer)
            optional(:max).maybe(:integer)

            optional(:task_schedule).schema do
              required(:schedule).filled(:string)

              optional(:start).maybe(:date_time)
              optional(:stop).maybe(:date_time)

              optional(:days).schema do
                DAYS.each do |day|
                  required(day).schema do
                    required(:on).maybe(:integer, gt?: 0, lt?: 86_400_000)
                    required(:off).maybe(:integer, gt?: 0, lt?: 86_400_000)
                  end
                end
              end
            end
          end
        end
      end

      DAYS.each do |day|
        rule(relay: { task: { task_schedule: { days: day }}}) do
          key.failure('on should be before off') unless (value[:on].nil? && value[:off].nil?) ||
            (value[:on] && value[:off] && value[:off] > value[:on])
        end
      end

      rule(relay: { task: { task_schedule: :start }}) do
        start = value
        stop = values.data.dig(:relay, :task, :task_schedule, :stop)

        key.failure('start should be before stop') unless (start.nil? && stop.nil?) || 
          (start && stop && start < stop)
      end
    end
  end
end
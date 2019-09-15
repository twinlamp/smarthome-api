Dry::Validation.schema('relays.update') do
  required(:relay).schema do
    required(:id).filled(:int?)
    required(:icon).filled(:str?)
    required(:name).filled(:str?)
    required(:state).filled(:str?, included_in?: Relay.states.keys)

    required(:sensor).schema do
      required(:id).filled(:int?)
    end

    optional(:task).schema do
      optional(:min).maybe(:int?)
      optional(:max).maybe(:int?)

      optional(:task_schedule).schema do
        optional(:start).maybe(:datetime?)
        optional(:stop).maybe(:datetime?)

        optional(:days).schema do
          %i[mon tue wed thu fri sat sun].each do |day|
            required(day).schema do
              required(:on).maybe(:time?)
              required(:off).maybe(:time?)
            end
          end
        end
      end
    end
  end
end
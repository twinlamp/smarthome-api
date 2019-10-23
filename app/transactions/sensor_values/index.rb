# frozen_string_literal: true

module Transactions
  module SensorValues
    class Index
      include Dry::Transaction(container: SmarthomeApi::Container)

      step :validate, with: 'validations.sensor_values.index'
      try :find_sensor, catch: ActiveRecord::RecordNotFound
      check :policy, with: 'policies.device_owner'
      step :find_values

      private

      def find_sensor(input)
        sensor = ::Sensor.find(input[:params][:sensor_id])
        input.merge(model: sensor)
      end

      def find_values(input)
        sv = SensorValue.find_by_sql(
          [
            %(
              SELECT *
              FROM  (
                      SELECT sensor_values.*,
                             ROW_NUMBER() OVER(ORDER BY registered_at) as rnk,
                             COUNT(*) OVER() as total_cnt
                      FROM sensor_values
                      WHERE
                        (registered_at between :from and :to) or
                        (registered_at > :from and :to IS NULL) or
                        (registered_at < :to and :from IS NULL) or
                        (:to is NULL and :from IS NULL)
                      ORDER BY registered_at
                    ) as data
              WHERE MOD(rnk,((CASE WHEN total_cnt > 0 THEN total_cnt ELSE 1.0 END)/200)) = 0
            ), from: input[:params][:from], to: input[:params][:to]
          ]
        )

        Success(input.merge(data: sv))
      end
    end
  end
end

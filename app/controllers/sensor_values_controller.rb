class SensorValuesController < ApplicationController
  include SmarthomeApi::Import[
    index_sensor_value: 'transactions.sensor_values.index'
  ]

  api :GET, '/v1/sensor_values', 'Values List For Sensor'
  param :sensor_id, String, required: true, desc: 'Sensor ID'
  param :from, String, required: false, desc: 'Values from DateTime'
  param :to, String, required: false, desc: 'Values until DateTime'
  formats ['json']
  example <<-EOS
    REQUEST:
    {
      "sensor_id": 1,
      "from": "2019-03-09T11:48:18.199Z",
      "to": "2019-03-12T11:48:18.199Z"
    }

    RESPONSE:
    [
      {
        "value": "36.77",
        "registered_at": "2019-03-11T11:48:18.199Z"
      }
    ]
  EOS
  def index
    index_sensor_value.(user: current_user, params: params) do |m|
      m.success do |result|
        render json: { data: ::SensorValueRepresenter.for_collection.new(result[:data]) }, status: :ok
      end

      m.failure :policy do
        head :forbidden
      end

      m.failure :find_sensor do
        head :not_found
      end

      m.failure do |errors|
        render json: { errors: errors }, status: :unprocessable_entity
      end
    end
  end
end
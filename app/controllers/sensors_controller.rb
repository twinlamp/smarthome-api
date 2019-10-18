class SensorsController < ApplicationController
  include SmarthomeApi::Import[
    update_sensor: 'transactions.sensors.update',
    show_sensor: 'transactions.sensors.show'
  ]

  api :PUT, '/v1/sensors/{id}', 'Update sensor data'
  formats ['json']
  param :id, String, required: true, desc: 'Sensor ID'
  param :sensor, Object, required: true, desc: 'Sensor data'
  example <<-EOS
  REQUEST:
  {
    "sensor": {
      "name": "test",
      "icon": "temperature",
      "min"=>0.0,
      "max"=>0.1e3  
    }
  }

  RESPONSE:
  {
    "sensor": {
      "id"=>1,
      "icon"=>"temperature",
      "title"=>"test",
      "name"=>"test",
      "min"=>0.0,
      "max"=>0.1e3,
      "value"=>23
    }
  }
  EOS
  def update
    update_sensor.(user: current_user, params: params) do |m|
      m.success do |response|
        render json: { sensor: ::SensorRepresenter.new(response[:model]) }, status: :ok
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

  api :GET, '/v1/sensors/{id}', 'Sensor with ID'
  formats ['json']
  param :id, String, required: true, desc: 'Sensor ID'
  example <<-EOS
  RESPONSE:
  {
    "sensor": {
      "id"=>1,
      "icon"=>"temperature",
      "title"=>"test",
      "name"=>"test",
      "min"=>0.0,
      "max"=>0.1e3,
      "value"=>23
    }
  }
  EOS
  def show
    show_sensor.(user: current_user, params: params) do |m|
      m.success do |response|
        render json: { sensor: ::SensorRepresenter.new(response[:model]).to_hash(user_options: { with_values: true }) }, status: :ok
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
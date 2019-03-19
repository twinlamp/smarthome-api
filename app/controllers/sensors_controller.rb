class SensorsController < ApplicationController

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
    @sensor = Sensor.where(device_id: current_user.device_ids).find(params[:id])
    if @sensor.update(sensor_params)
      render json: { sensor: ::SensorRepresenter.new(@sensor) }, status: :ok
    else
      render json: { errors: @sensor.errors }, status: :unprocessable_entity
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
    @sensor = Sensor.where(device_id: current_user.device_ids).find(params[:id])
    render json: { sensor: ::SensorRepresenter.new(@sensor).to_hash(user_options: { with_values: true }) }, status: :ok
  end

  private

  def sensor_params
    params.require(:sensor).permit(:name, :icon, :min, :max)
  end 
end
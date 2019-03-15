class Api::SensorValuesController < ApplicationController

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
    sensor = Sensor.where(device_id: current_user.device_ids).find(params[:sensor_id])
    @sensor_values = sensor.values.filter_by_dates(params[:from], params[:to]).limit_to_n_elements(200)
    render json: ::SensorValueRepresenter.for_collection.new(@sensor_values), status: :ok
  end
end
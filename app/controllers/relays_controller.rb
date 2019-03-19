class RelaysController < ApplicationController

  api :PUT, '/v1/relays/{id}', 'Update relay data'
  formats ['json']
  param :id, String, required: true, desc: 'Relay ID'
  param :relay, Object, required: true, desc: 'Relay data'
  example <<-EOS
  REQUEST:
  {
    "relay": {
      "name": "boiler",
      "icon": "radiator",
      "state": "on",
      "sensor_id": 1
    }
  }

  RESPONSE:
  {
    "relay": {
      "id"=>1,
      "icon"=>"radiator",
      "title"=>"boiler",
      "name"=>"boiler",
      "sensor"=>{
        "id"=>1,
        "icon"=>"temperature",
        "title"=>"test",
        "name"=>"test",
        "min"=>0.0,
        "max"=>0.1e3,
        "value"=>23,
        "device_id"=>2
      },
      "value"=>false,
      "state"=>"on",
    }
  }
  EOS
  def update
    @relay = Relay.where(device_id: current_user.device_ids).find(params[:id])
    if @relay.update(relay_params)
      render json: { relay: ::RelayRepresenter.new(@relay) }, status: :ok
    else
      render json: { errors: @relay.errors }, status: :unprocessable_entity
    end
  end

  api :GET, '/v1/relays/{id}', 'Relay with ID'
  formats ['json']
  param :id, String, required: true, desc: 'Relay ID'
  example <<-EOS
  RESPONSE:
  {
    "relay": {
      "id"=>1,
      "icon"=>"radiator",
      "title"=>"boiler",
      "name"=>"boiler",
      "sensor"=>{
        "id"=>1,
        "icon"=>"temperature",
        "title"=>"test",
        "name"=>"test",
        "min"=>0.0,
        "max"=>0.1e3,
        "value"=>23,
        "device_id"=>2
      },
      "value"=>false,
      "state"=>"on",
      "device_id"=>2,
      "possible_sensors"=>[
        {
          "id"=>1,
          "icon"=>"temperature",
          "title"=>"test",
          "name"=>"test",
          "min"=>0.0,
          "max"=>0.1e3,
          "value"=>23,
          "device_id"=>2
        },
        {
          "id"=>2,
          "icon"=>"humidity",
          "title"=>"test hum",
          "name"=>"test hum",
          "min"=>0.0,
          "max"=>0.1e3,
          "value"=>50,
          "device_id"=>2
        }
      ]}
    }
  }
  EOS
  def show
    @relay = Relay.where(device_id: current_user.device_ids).find(params[:id])
    render json: { relay: ::RelayRepresenter.new(@relay).to_hash(user_options: { with_possible_sensors: true }) }, status: :ok
  end

  private

  def relay_params
    params.require(:relay).permit(:name, :icon, :state, :sensor_id)
  end 
end
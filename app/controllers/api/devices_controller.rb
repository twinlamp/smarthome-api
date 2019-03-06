class Api::DevicesController < ApplicationController

  api :GET, '/v1/devices', 'Device List'
  formats ['json']
  example <<-EOS
    RESPONSE:
    [
      {
        "name": "new device",
        "timezone": "Europe/Moscow",
        "identity": "dsfadfweeeeeeeee234"
      }
    ]
  EOS
  def index
    @devices = current_user&.devices
    render json: ::DeviceRepresenter.for_collection.new(@devices), status: :ok
  end

  api :POST, '/v1/devices', 'Create device'
  formats ['json']
  error code: 422, desc: 'Wrong validation'
  param :device, Object, required: true, desc: 'Device data'
  example <<-EOS
  REQUEST:
  {
    "device": {
      "name": "test device",
      "avatar": "Europe/Moscow",      
    }
  }

  RESPONSE:
  {
    "device": {
      "id": 1,
      "name": "test device",
      "identity": "5bVondZsV9fwCPjoZcg2KmEq",
      "timezone": "Europe/Moscow"
    }
  }
  EOS
  def create
    @device = current_user.devices.new(device_params)
    if @device.save
      render json: { device: ::DeviceRepresenter.new(@device) }, status: :created
    else
      render json: { errors: @device.errors }, status: :unprocessable_entity
    end
  end

  api :PUT, '/v1/devices/{id}', 'Update device data'
  formats ['json']
  param :id, String, required: true, desc: 'Device ID'
  param :device, Object, required: true, desc: 'Device data'
  example <<-EOS
  REQUEST:
  {
    "device": {
      "name": "test device",
      "avatar": "Europe/Moscow",      
    }
  }

  RESPONSE:
  {
    "device": {
      "id": 1,
      "name": "test device",
      "identity": "5bVondZsV9fwCPjoZcg2KmEq",
      "timezone": "Europe/Moscow"
    }
  }
  EOS
  def update
    @device = current_user.devices.find(params[:id])
    if @device.update(device_params)
      render json: { device: ::DeviceRepresenter.new(@device) }, status: :ok
    else
      render json: { errors: @device.errors }, status: :unprocessable_entity
    end
  end

  api :GET, '/v1/devices/{id}', 'Device with ID'
  formats ['json']
  param :id, String, required: true, desc: 'Device ID'
  example <<-EOS
  RESPONSE:
  {
    "device": {
      "id": 1,
      "name": "test device",
      "identity": "5bVondZsV9fwCPjoZcg2KmEq",
      "timezone": "Europe/Moscow"
    }
  }
  EOS
  def show
    @device = current_user.devices.find(params[:id])
    render json: { device: ::DeviceRepresenter.new(@device).to_hash(user_options: { with_children: true }) }, status: :ok
  end

  private

  def device_params
    params.require(:device).permit(:name, :timezone)
  end 
end
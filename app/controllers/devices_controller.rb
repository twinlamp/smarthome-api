class DevicesController < ApplicationController
  include SmarthomeApi::Import[
    index_device: 'transactions.devices.index',
    create_device: 'transactions.devices.create',
    update_device: 'transactions.devices.update',
    show_device: 'transactions.devices.show',
  ]

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
    index_device.(user: current_user) do |m|
      m.success do |result|
        render json: { data: ::DeviceRepresenter.for_collection.new(result[:data]) }, status: :ok
      end

      m.failure :policy do
        head :forbidden
      end
    end
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
    create_device.(user: current_user, params: params) do |m|
      m.success do |result|
        render json: { relay: ::DeviceRepresenter.new(result[:model]) }, status: :created
      end

      m.failure :policy do
        head :forbidden
      end

      m.failure do |errors|
        render json: { errors: errors }, status: :unprocessable_entity
      end
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
    update_device.(user: current_user, params: params) do |m|
      m.success do |result|
        render json: { relay: ::DeviceRepresenter.new(result[:model]) }, status: :ok
      end

      m.failure :policy do
        head :forbidden
      end

      m.failure :find_device do
        head :not_found
      end

      m.failure do |errors|
        render json: { errors: errors }, status: :unprocessable_entity
      end
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
    byebug
    show_device.(user: current_user, params: params) do |m|
      m.success do |response|
        render json: { device: ::DeviceRepresenter.new(response[:model]).to_hash(user_options: { with_children: true }) }, status: :ok
      end

      m.failure :policy do
        head :forbidden
      end

      m.failure :find_device do
        head :not_found
      end

      m.failure do |errors|
        render json: { errors: errors }, status: :unprocessable_entity
      end
    end
  end
end
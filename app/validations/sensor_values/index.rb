# frozen_string_literal: true

module Validations
  module SensorValues
    class Index < Validator
      params do
        required(:sensor_id).filled(:integer)
        optional(:from).filled(:date_time)
        optional(:to).filled(:date_time)
      end
    end
  end
end

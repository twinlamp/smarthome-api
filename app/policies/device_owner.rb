# frozen_string_literal: true

module Policies
  class DeviceOwner
    def call(user:, model:, **)
      model.device&.user == user
    end
  end
end

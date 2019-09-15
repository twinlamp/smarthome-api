# frozen_string_literal: true

module ParamsHash
  private

  # Convert `params` to hash, optionally extracting nested hash introduced by
  # https://apidock.com/rails/ActionController/ParamsWrapper if `key` is given.
  def params_hash(key = nil)
    hash = key.nil? ? params : params[key]
    hash.respond_to?(:to_unsafe_hash) ? hash.to_unsafe_hash : {}
  end
end

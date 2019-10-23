# frozen_string_literal: true

module Validations
  module Users
    class Create < Validator
      params do
        required(:email).filled(:string)
        required(:password).filled(:string, min_size?: 8, max_size?: 40)
      end

      rule(:email) do
        key.failure('must be unique') unless User.where(email: value).none?
      end
    end
  end
end

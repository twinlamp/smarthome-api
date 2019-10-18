module Validations
  module Users
    class Auth < Validator

      params do
        required(:email).filled(:string)
        required(:password).filled(:string)
      end
    end
  end
end
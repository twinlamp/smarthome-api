# frozen_string_literal: true

module Policies
  class AuthenticatedUser
    def call(user:, **)
      user&.id.present?
    end
  end
end

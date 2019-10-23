# frozen_string_literal: true

class ApplicationController < ActionController::API
  include Knock::Authenticable

  before_action :authenticate_user
end

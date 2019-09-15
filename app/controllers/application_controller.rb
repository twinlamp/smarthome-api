class ApplicationController < ActionController::API
  include ParamsHash
  include Knock::Authenticable

  before_action :authenticate_user
end

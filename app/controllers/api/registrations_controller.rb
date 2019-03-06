class Api::RegistrationsController < ApplicationController
  skip_before_action :authenticate_user

  api :POST, '/v1/auth/sign_up', 'User registration'
  formats ['json']
  error code: 422, desc: 'User exists or wrong validation'
  param :email, String, required: true, desc: 'Email'
  param :password, String, required: true, desc: 'Password'
  example <<-EOS
    PROFILE:

    {
      "email": "aaa@bbb.cc",
      "password": "qwerty"
    }

    RESPONSE:
    {
      "token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9",
      "expire": "2019-03-13T11:16:05.126+00:00",
      "user": {
        "id": 5,
        "email": "aaa@bbb3.cc",
        "password_digest": "$2a$10$Y0jiiw6kaBmxjfItKFwpbuDjdssEmCWv7iUxQzEDwBjh3cbcVpm7q"
      }
    }
  EOS
  def create
    @user = User.create(user_params)
    if @user.persisted?
      jwt = Knock::AuthToken.new(payload: { sub: @user.id }).token
      render json: { token: token, expire: DateTime.now + Knock.token_lifetime, user: @user }, status: :created
    else
      render json: { errors: @user.errors }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.permit(:email, :password)
  end 
end
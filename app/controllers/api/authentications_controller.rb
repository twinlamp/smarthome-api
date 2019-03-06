class Api::AuthenticationsController < ApplicationController
  skip_before_action :authenticate_user

  api :POST, '/v1/auth/sign_in', 'User authentication'
  formats ['json']
  error code: 401, desc: 'Wrong email or password'
  param :email, String, required: true, desc: 'Email'
  param :password, String, required: true, desc: 'Password'
  example <<-EOS
    REQUEST
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
    @user = User.find_by(email: auth_params[:email])
    if @user&.authenticate(auth_params[:password])
      jwt = Knock::AuthToken.new(payload: { sub: @user.id }).token
      render json: { token: jwt, expire: DateTime.now + Knock.token_lifetime, user: ::UserRepresenter.new(@user) }, status: :created
    else
      render json: { errors: { email: 'Wrong email or password' } }, status: :unprocessable_entity
    end
  end

  private

  def auth_params
    params.permit(:email, :password)
  end
end

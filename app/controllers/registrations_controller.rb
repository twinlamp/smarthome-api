# frozen_string_literal: true

class RegistrationsController < ApplicationController
  include SmarthomeApi::Import[
    create_user: 'transactions.users.create'
  ]

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
    create_user.(params: params) do |m|
      m.success do |result|
        render json: { token: result[:token], expire: result[:expire], user: ::UserRepresenter.new(result[:model]) }, status: :ok
      end

      m.failure do |errors|
        render json: { errors: errors }, status: :unprocessable_entity
      end
    end
  end
end

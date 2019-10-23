# frozen_string_literal: true

Rails.application.routes.draw do
  scope :api do
    scope :v1 do
      scope :auth do
        post :sign_up, to: 'registrations#create'
        post :sign_in, to: 'authentications#create'
      end
      resources :devices
      resources :sensors, only: %i[show update]
      resources :relays, only: %i[show update]
      resources :sensor_values, only: :index
    end
  end
end

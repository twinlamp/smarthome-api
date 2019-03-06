Rails.application.routes.draw do
  namespace :api do
    scope :v1 do
      scope :auth do
        post :sign_up, to: 'registrations#create'
        post :sign_in, to: 'authentications#create'
      end
    end
  end
end

module Transactions
  module Users
    class Auth
      include Dry::Transaction(container: SmarthomeApi::Container)

      step :validate, with: 'validations.users.auth'
      step :auth_user
      step :calculate_token

      private

      def auth_user(input)
        user = User.find_by(email: input[:params][:email])
        if user&.authenticate(input[:params][:password])
          Success(input.merge(model: user))
        else
          Failure(email: ['Wrong email or password'])
        end
      end

      def calculate_token(input)
        jwt = Knock::AuthToken.new(payload: { sub: input[:model].id }).token
        expire = DateTime.now + Knock.token_lifetime
        Success(input.merge(token: jwt, expire: expire))
      end
    end
  end
end

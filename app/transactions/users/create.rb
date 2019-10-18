module Transactions
  module Users
    class Create
      include Dry::Transaction(container: SmarthomeApi::Container)

      step :validate, with: 'validations.users.create'
      step :create_user
      step :calculate_token

      private

      def create_user(input)
        user = User.create!(input[:params])
        Success(input.merge(model: user))
      end

      def calculate_token(input)
        jwt = Knock::AuthToken.new(payload: { sub: input[:model].id }).token
        expire = DateTime.now + Knock.token_lifetime
        Success(input.merge(token: jwt, expire: expire))
      end
    end
  end
end

# frozen_string_literal: true

class Validator < Dry::Validation::Contract
  def call(input)
    result = super(input[:params].permit!.to_h)

    return Dry::Monads::Result::Failure.new(result.errors.to_h) if result.failure?

    Dry::Monads::Result::Success.new(input.merge(params: result.schema_result.output).to_h.deep_symbolize_keys)
  end
end

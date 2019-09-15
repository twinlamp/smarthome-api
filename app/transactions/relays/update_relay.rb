# frozen_string_literal: true

module Transactions
  module Relays
    class UpdateRelay < Dry::Transaction
      step :validate
      step :find_relay
      check :policy
      step :update

      private

      def validate(input)

      end

      def find_relay(input)
        relay = ::Relay.find(input.dig(:params, :relay, :id))
        Success(input.merge(model: relay))
      end

      def policy(input)
        input[:model].device.user == params[:user]
      end

      def update(input)
        ActiveRecord::Base.transaction do
          input[:model].update_attributes(input.dig(:params, :relay))
          input[:model].task
          file.save
          file.attachment.save
        end
      end

      def set_params(input)
        input[:params].merge!(
          author_id: input[:user].id,
          resource_type: ::Review.resource_types[:organization],
          reliable: input[:finished_courses].count.positive?,
          meta: (input[:meta] || {}).to_json
        )
      end

      def check_limits(input)
        reviews_count = ::Review.organization.by_author(input[:params]).for_the_last_year.count
        reliable = input.dig(:params, :reliable)

        return Failure(::Reviews::Errors.messages.for(id: :too_many_reviews?)) if
          reviews_count > 1 || (!reliable && reviews_count.positive?)

        Success(input)
      end

      def create(input)
        review = ::Review.new(input[:params])

        review.save! && review.reload
        Success(input.merge(model: review))
      end

      def fetch_manager_emails(input)
        FetchOrganizationManagerEmailsJob.perform_later(input[:model].id)
      end

      def notify(input)
        event_type = Notifications::REV_CREATE

        Notifications::Create.new(review_id: input[:model].id, event_type: event_type).call
      end
    end
  end
end

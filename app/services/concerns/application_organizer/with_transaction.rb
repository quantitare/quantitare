# frozen_string_literal: true

module ApplicationOrganizer
  ##
  # Wrap a set of actions in an ActiveRecord transaction
  #
  #   class DoSomeStuff
  #     include ApplicationOrganizer
  #
  #     class << self
  #       def call(**params)
  #         with(params).reduce([
  #           with_transaction([
  #             DeleteSomething,
  #             CreateSomething,
  #             UpdateSomething
  #           ])
  #         ])
  #       end
  #     end
  #   end
  #
  class WithTransaction
    extend LightService::Organizer::ScopedReducable

    class << self
      def run(organizer, steps)
        ->(ctx) {
          return ctx if ctx.stop_processing?

          ApplicationRecord.transaction do
            ctx = scoped_reduce(organizer, ctx, steps)
          rescue ActiveRecord::Rollback => e
            ctx.fail! 'Transaction rolled back'
            raise e
          end

          ctx
        }
      end
    end
  end
end

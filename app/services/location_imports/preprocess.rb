# frozen_string_literal: true

module LocationImports
  # @private
  class Preprocess
    extend LightService::Action

    expects :location_import
    promises :location_scrobbles

    executed do |ctx|
      ctx.fail_and_return!('Could not preprocess the import') unless ctx.location_import.save

      ctx.location_scrobbles = ctx.location_import.prepared_adapter_scrobbles
    end

    rolled_back do |ctx|
      ctx.location_import.destroy
    end
  end
end

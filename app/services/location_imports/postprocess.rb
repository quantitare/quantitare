# frozen_string_literal: true

module LocationImports
  # @private
  class Postprocess
    extend LightService::Action

    expects :location_import

    executed do |ctx|
      ctx.fail!('Could not persist the import and its associated scrobbles') unless ctx.location_import.save
    end
  end
end

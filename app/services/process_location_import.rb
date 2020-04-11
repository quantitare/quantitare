# frozen_string_literal: true

##
# Defines the workflow for creating a {LocationImport}
#
class ProcessLocationImport
  include ApplicationOrganizer

  class << self
    def call(location_import, options = {})
      with(location_import: location_import, options: options.symbolize_keys)
        .reduce(actions)
    end

    def actions
      [
        LocationImports::Preprocess,

        iterate(:location_scrobbles, [
          LocationImports::AddScrobble,
          execute(->(ctx) { ctx[:save] = false }),

          ProcessLocationScrobble.actions
        ]),

        LocationImports::Postprocess
      ]
    end
  end
end

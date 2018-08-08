# frozen_string_literal: true

##
# Mix in to an adapter to
#
module LocationImportable
  extend ActiveSupport::Concern

  class_methods do
    def for_location_import(location_import)
      contents = location_import.import_file.download
      load_file_contents(contents)
    end
  end
end

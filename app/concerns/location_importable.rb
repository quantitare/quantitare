# frozen_string_literal: true

##
# Mix in to an adapter to
#
module LocationImportable
  extend ActiveSupport::Concern

  class_methods do
    def load_import(import)
      contents = File.load(import.import_file)
      load_file_contents(contents)
    end
  end
end

# frozen_string_literal: true

module Aux
  ##
  # Diff info for a {Aux::CodeCommit}
  #
  class CodeDiff
    include AttrJson::Model

    attr_json :files_changed, :integer, default: 0
    attr_json :additions, :integer, default: 0
    attr_json :deletions, :integer, default: 0
  end
end

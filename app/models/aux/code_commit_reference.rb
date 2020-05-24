# frozen_string_literal: true

module Aux
  ##
  # Minimal information for looking up a {Aux::CodeCommit} record from another {Aux::CodeCommit} record.
  #
  class CodeCommitReference
    include AttrJson::Model

    attr_json :sha, :string

    validates :sha, presence: true
  end
end

# frozen_string_literal: true

module Aux
  ##
  # A representation of a commit made in a source control system
  #
  class CodeCommit < ServiceCache
    attr_json :repository_name, :string
    attr_json :sha, :string
    attr_json :message, :string

    attr_json :author, Aux::CodeParticipant.to_type
    attr_json :committer, Aux::CodeParticipant.to_type

    attr_json :diff, Aux::CodeDiff.to_type
    attr_json :parents, Aux::CodeCommitReference.to_type, array: true, default: proc { [] }

    validates :repository_name, presence: true
    validates :sha, presence: true

    fetcher :repository_name_and_sha, [:repository_name, :sha]
  end
end

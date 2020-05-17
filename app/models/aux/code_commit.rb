# frozen_string_literal: true

module Aux
  ##
  # A representation of a commit made in a source control system
  #
  class CodeCommit < ServiceCache
    store_accessor :data, :repository_name, :sha, :author, :committer, :message, :parents, :diff

    json_schema :data, Rails.root.join('app', 'models', 'json_schemas', 'aux', 'code_commit_data_schema.json')

    fetcher :repository_name_and_sha, [:repository_name, :sha]
  end
end

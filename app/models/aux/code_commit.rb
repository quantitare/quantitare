# frozen_string_literal: true

module Aux
  ##
  # A representation of a commit made in a source control system
  #
  class CodeCommit < ServiceCache
    jsonb_accessor :data,
      repository_name: :string,
      sha: :string,
      author: :json,
      committer: :json,
      message: :string,
      parents: :json,
      diff: :json

    json_schema :data, Rails.root.join('app', 'models', 'json_schemas', 'aux', 'code_commit_data_schema.json')

    fetcher :repository_name_and_sha, [:repository_name, :sha]
  end
end

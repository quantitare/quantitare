# frozen_string_literal: true

class GithubAdapter
  ##
  # @private
  #
  class Scrobble
    class << self
      def commit_from_api(code_commit, raw_repo)
        new(code_commit, raw_repo)
      end
    end

    attr_reader :code_commit, :raw_repo

    def initialize(code_commit, raw_repo)
      @code_commit = code_commit
      @raw_repo = raw_repo
    end

    def to_scrobble
      ::Scrobble.new(
        category: 'code_commit',
        timestamp: timestamp,

        data: data
      )
    end

    private

    def timestamp
      Time.zone.parse(code_commit.author['date'])
    end

    def data
      {
        repository_name: raw_repo.full_name,
        sha: code_commit.sha,
        message: code_commit.message,

        author: author,
        committer: committer,

        diff: diff
      }
    end

    def author
      {
        name: code_commit.author['name'],
        email: code_commit.author['email']
      }
    end

    def committer
      {
        name: code_commit.committer['name'],
        email: code_commit.committer['email']
      }
    end

    def diff
      {
        files_changed: code_commit.diff['files_changed'],
        additions: code_commit.diff['additions'],
        deletions: code_commit.diff['deletions']
      }
    end
  end
end

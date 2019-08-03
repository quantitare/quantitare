# frozen_string_literal: true

class GithubAdapter
  ##
  # @private
  #
  class CodeCommit
    attr_reader :raw_commit, :repository_name, :adapter

    def initialize(raw_commit, repository_name, adapter)
      @raw_commit = raw_commit
      @repository_name = repository_name
      @adapter = adapter
    end

    def to_aux
      ::Aux::CodeCommit.new(
        service: adapter.service,
        service_identifier: service_identifier,

        data: data,

        expires_at: 1.week.from_now
      )
    end

    def service_identifier
      "#{repository_name}:#{raw_commit.sha}"
    end

    def data
      {
        repository_name: repository_name,
        sha: raw_commit.sha,
        message: raw_commit.commit.message,

        author: author,
        committer: committer,

        diff: diff,

        parents: parents
      }
    end

    def author
      {
        name: raw_commit.commit.author.name,
        email: raw_commit.commit.author.email,
        date: raw_commit.commit.author.date.iso8601
      }
    end

    def committer
      {
        name: raw_commit.commit.committer.name,
        email: raw_commit.commit.committer.email,
        date: raw_commit.commit.committer.date.iso8601
      }
    end

    def diff
      {
        files_changed: raw_commit.files.length,
        additions: raw_commit.stats.additions,
        deletions: raw_commit.stats.deletions
      }
    end

    def parents
      raw_commit.parents.map { |parent| { sha: parent.sha } }
    end
  end
end

# frozen_string_literal: true

##
# API wrapper for the GitHub API.
#
# == Request cadence
#
# This adapter uses a pattern that is similar to the other adapters found in Quantitare, but we set Octokit's
# +auto_paginate+ parameter to +true+. This means that every time we query the client, there may be several HTTP
# requests made by the client. It is best to keep the ranges for which you make requests as small as possible to
# avoid hitting GitHub's rate limits.
#
class GithubAdapter
  attr_reader :service, :cadence

  def initialize(service, cadence: 0.seconds)
    @service = service
    @cadence = cadence
  end

  def client
    @client ||= Octokit::Client.new(access_token: service.token).tap do |c|
      c.auto_paginate = true
    end
  end

  def fetch_scrobbles(start_time, end_time)
    fetch_raw_repositories.flat_map { |raw_repo| scrobbles_for_raw_repository(raw_repo, start_time, end_time) }
  end

  def fetch_code_commit(opts = {})
    raw_commit = fetch_raw_commit(opts[:repository_name], opts[:sha])

    GithubAdapter::CodeCommit.new(raw_commit, opts[:repository_name], self).to_aux
  end

  private

  def service_author
    service.options['name']
  end

  def wrap_api_request
    result = yield

    sleep cadence

    result
  rescue Faraday::ConnectionFailed, Faraday::TimeoutError, Octokit::TooManyRequests, Octokit::AbuseDetected => e
    raise Errors::ServiceAPIError, e.message
  end

  def scrobbles_for_raw_repository(raw_repo, start_time, end_time)
    return [] unless (start_time..end_time).overlaps?(raw_repo.created_at..raw_repo.pushed_at)

    raw_commit_activities = raw_commit_activities_for_repository(
      raw_repo, start_time, end_time, author: service_author
    )

    raw_commit_activities.map { |raw_commit_activity| scrobble_for_raw_commit_activity(raw_commit_activity, raw_repo) }
  end

  def scrobble_for_raw_commit_activity(raw_commit_activity, raw_repo)
    commit = ::Aux::CodeCommit.fetch(repository_name: raw_repo.full_name, sha: raw_commit_activity.sha, adapter: self)
    GithubAdapter::Scrobble.commit_from_api(commit, raw_repo).to_scrobble
  end

  def fetch_raw_repositories
    wrap_api_request { client.repositories }
  end

  def raw_commit_activities_for_repository(raw_repo, start_time, end_time, options = {})
    wrap_api_request { client.commits_between(raw_repo.full_name, start_time, end_time, options) }
  end

  def fetch_raw_commit(repo_name, sha)
    wrap_api_request { client.commit(repo_name, sha) }
  end
end

require_dependency 'github_adapter/scrobble'

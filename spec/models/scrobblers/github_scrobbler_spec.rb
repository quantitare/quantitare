# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Scrobblers::GithubScrobbler do
  it { should delegate_method(:fetch_scrobbles).to(:adapter).with_arguments(5.minutes.ago, 1.minute.ago) }

  describe '#adapter' do
    it 'returns a scrobble-fetchable adapter' do
      expect(Scrobblers::GithubScrobbler.new(service: create(:service, :github)).adapter).to(
        respond_to(:fetch_scrobbles)
      )
    end
  end
end

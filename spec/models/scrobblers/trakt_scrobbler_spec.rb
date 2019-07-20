# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Scrobblers::TraktScrobbler, :vcr do
  subject { create :trakt_scrobbler }

  describe '#fetch_and_format_scrobbles' do
    let(:action) do
      subject.fetch_and_format_scrobbles(
        Time.zone.parse('2019-02-01 00:00:00 UTC'), Time.zone.parse('2019-02-15 00:00:00 UTC')
      )
    end

    it_behaves_like 'fetchable_scrobbler'
  end
end

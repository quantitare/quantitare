# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Scrobblers::TraktScrobbler, :vcr do
  subject { create :trakt_scrobbler }

  it_behaves_like 'fetchable_scrobbler',
    Time.zone.parse('2019-02-01 00:00:00 UTC'), Time.zone.parse('2019-02-15 00:00:00 UTC')
end

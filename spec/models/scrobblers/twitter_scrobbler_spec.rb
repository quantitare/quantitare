# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Scrobblers::TwitterScrobbler, :vcr do
  subject { create :twitter_scrobbler }

  it_behaves_like 'fetchable_scrobbler', Time.zone.parse('2019-07-20 00:00:00'), Time.zone.parse('2019-07-23 00:00:00')
end

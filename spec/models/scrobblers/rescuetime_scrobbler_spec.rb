# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Scrobblers::RescuetimeScrobbler do
  subject { create :rescuetime_scrobbler }

  describe '#fetch_and_format_scrobbles', :vcr do
    it 'returns a list of scrobbles' do
      result = subject.fetch_and_format_scrobbles(
        Time.zone.parse('2019-07-01 05:27:04 UTC'),
        Time.zone.parse('2019-07-02 05:27:04 UTC')
      )

      expect(result.all? { |item| item.is_a?(::Scrobble) }).to be(true)
    end

    it 'returns a list of valid records' do
      result = subject.fetch_and_format_scrobbles(
        Time.zone.parse('2019-07-01 05:27:04 UTC'),
        Time.zone.parse('2019-07-02 05:27:04 UTC')
      )

      expect(result.all?(&:valid?)).to be(true)
    end
  end
end

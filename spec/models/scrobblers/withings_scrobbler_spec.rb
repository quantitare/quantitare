require 'rails_helper'

RSpec.describe Scrobblers::WithingsScrobbler do
  let(:scrobbler) { create :withings_scrobbler }

  describe '#fetch_and_format_scrobbles', :vcr do
    it 'returns a list of scrobbles' do
      result = scrobbler.fetch_and_format_scrobbles(
        Time.zone.parse('2019-07-01 05:27:04 UTC'),
        Time.zone.parse('2019-07-02 05:27:04 UTC')
      )

      expect(result.all? { |scr| scr.is_a?(::Scrobble) }).to be(true)
    end
  end
end

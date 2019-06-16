require 'rails_helper'

RSpec.describe Scrobble do
  let(:user) { create(:user) }
  let(:source) { create(:scrobbler) }

  describe '#derive_type' do
    it 'becomes a PointScrobble upon creation if the timestamps are present and the same' do
      time = 5.minutes.ago
      scrobble = Scrobble.new(
        user: user, source: source,
        category: 'log', start_time: time, end_time: time,
        data: { content: 'foo' }
      )

      scrobble.save!
      expect(scrobble.type).to eq('PointScrobble')
    end

    it 'becomes a PointScrobble if the timestamp attribute is set' do
      time = 5.minutes.ago
      scrobble = Scrobble.new(
        user: user, source: source,
        category: 'log', timestamp: time,
        data: { content: 'foo' }
      )

      scrobble.save!
      expect(scrobble.type).to eq('PointScrobble')
    end

    it 'does not become a PointScrobble if the record has already been persisted' do
      start_time = 5.minutes.ago
      end_time = 4.minutes.ago
      scrobble = Scrobble.new(
        user: user, source: source,
        category: 'log', start_time: start_time, end_time: end_time,
        data: { content: 'foo' }
      )

      scrobble.save!
      expect(scrobble.type).to be_blank # sanity check

      scrobble.update!(timestamp: 3.minutes.ago)
      expect(scrobble.type).to be_blank
    end
  end
end

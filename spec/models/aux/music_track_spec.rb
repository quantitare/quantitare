# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Aux::MusicTrack do
  subject { build :music_track }
  let(:service) { nil }
  let(:adapter) { double 'adapter', service: service, fetch_music_track: subject }

  describe '.fetch' do
    let(:options) { { adapter: adapter } }
    let(:action) { Aux::MusicTrack.fetch(options) }

    context 'when MBID is provided' do
      let(:mbid) { SecureRandom.uuid }
      let(:options) { { mbid: mbid, adapter: adapter } }

      context 'when there is an unexpired cache' do
        subject { create :music_track, mbid: mbid }

        it 'retrieves the cached record' do
          expect(action).to eq(subject)
        end

        it 'does not fetch anything from the adapter' do
          expect(adapter).to_not receive(:fetch_music_track)

          action
        end
      end

      context 'when the cache is expired' do
        subject { create :music_track, :expired, mbid: mbid }

        it 'fetches data from the adapter' do
          expect(adapter).to receive(:fetch_music_track).and_return(subject)

          action
        end

        it 'does not create a new record' # TODO
      end

      context 'when there is no cache' do
        subject { build :music_track, mbid: mbid }

        it 'creates a new record' do
          expect { action }.to change(Aux::MusicTrack, :count).by(1)
        end

        it 'returns an Aux::MusicTrack record' do
          expect(action).to be_a(Aux::MusicTrack)
        end

        it 'returns one with a matching MBID' do
          expect(action.mbid).to eq(mbid)
        end
      end
    end

    context 'when title and artist are provided' do
      let(:title) { Faker::Dessert.flavor }
      let(:artist_name) { Faker::Music.band }
      let(:options) { { title: title, artist_name: artist_name, adapter: adapter } }

      context 'when there is an unexpired cache' do
        subject { create :music_track, title: title, artist_name: artist_name }

        it 'retrieves the cached record' do
          expect(action).to eq(subject)
        end

        it 'does not fetch anything from the adapter' do
          expect(adapter).to_not receive(:fetch_music_track)

          action
        end
      end

      context 'when the cache is expired' do
        subject { create :music_track, :expired, title: title, artist_name: artist_name }

        it 'fetches data from the adapter' do
          expect(adapter).to receive(:fetch_music_track).and_return(subject)

          action
        end

        it 'does not create a new record' # TODO
      end

      context 'when there is no cache' do
        subject { build :music_track, title: title, artist_name: artist_name }

        it 'creates a new record' do
          expect { action }.to change(Aux::MusicTrack, :count).by(1)
        end

        it 'returns an Aux::MusicTrack record' do
          expect(action).to be_a(Aux::MusicTrack)
        end

        it 'returns one with a matching title' do
          expect(action.title).to eq(title)
        end

        it 'returns one with a matching artist name' do
          expect(action.artist_name).to eq(artist_name)
        end
      end
    end
  end
end

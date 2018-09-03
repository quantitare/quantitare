# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Aux::MusicArtist do
  subject { build :music_artist }
  let(:service) { nil }
  let(:adapter) { double 'adapter', service: service, fetch_music_artist: subject }

  describe '.fetch' do
    let(:options) { { adapter: adapter } }
    let(:action) { Aux::MusicArtist.fetch(options) }

    context 'when MBID is provided' do
      let(:mbid) { SecureRandom.uuid }
      let(:options) { { mbid: mbid, adapter: adapter } }

      context 'when there is an unexpired cache' do
        subject { create :music_artist, mbid: mbid }

        it 'retrieves the cached record' do
          expect(action).to eq(subject)
        end

        it 'does not fetch anything from the adapter' do
          expect(adapter).to_not receive(:fetch_music_artist)

          action
        end
      end

      context 'when the cache is expired' do
        subject! { create :music_artist, :expired, mbid: mbid }

        it 'fetches data from the adapter' do
          expect(adapter).to receive(:fetch_music_artist).and_return(subject)

          action
        end

        it 'does not create a new record' do
          expect { action }.to change(Aux::MusicArtist, :count).by(0)
        end
      end

      context 'when there is no cache' do
        subject { build :music_artist, mbid: mbid }

        it 'creates a new record' do
          expect { action }.to change(Aux::MusicArtist, :count).by(1)
        end

        it 'returns an Aux::MusicArtist record' do
          expect(action).to be_a(Aux::MusicArtist)
        end

        it 'returns one with a matching MBID' do
          expect(action.mbid).to eq(mbid)
        end
      end
    end

    context 'when name is provided' do
      let(:name) { Faker::Music.band }
      let(:options) { { name: name, adapter: adapter } }

      context 'when there is an unexpired cache' do
        subject { create :music_artist, name: name }

        it 'retrieves the cached record' do
          expect(action).to eq(subject)
        end

        it 'does not fetch anything from the adapter' do
          expect(adapter).to_not receive(:fetch_music_artist)

          action
        end
      end

      context 'when the cache is expired' do
        subject! { create :music_artist, :expired, name: name }

        it 'fetches data from the adapter' do
          expect(adapter).to receive(:fetch_music_artist).and_return(subject)

          action
        end

        it 'does not create a new record' do
          expect { action }.to change(Aux::MusicArtist, :count).by(0)
        end
      end

      context 'when there is no cache' do
        subject { build :music_artist, name: name }

        it 'creates a new record' do
          expect { action }.to change(Aux::MusicArtist, :count).by(1)
        end

        it 'returns an Aux::MusicArtist record' do
          expect(action).to be_a(Aux::MusicArtist)
        end

        it 'returns one with a matching artist name' do
          expect(action.name).to eq(name)
        end
      end
    end
  end
end

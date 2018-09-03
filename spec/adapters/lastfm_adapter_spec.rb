# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LastfmAdapter, :vcr do
  let(:service) do
    build :service,
      uid: ENV['LASTFM_TEST_USER_UID'],
      token: ENV['LASTFM_TEST_USER_TOKEN'],
      provider: :lastfm
  end

  subject { LastfmAdapter.new(service) }

  describe '#fetch_music_track' do
    let(:opts) { {} }
    let(:action) { subject.fetch_music_track(opts) }

    context 'with an MBID' do
      let(:opts) { { mbid: 'a8b4bc8f-4ca4-4ae6-a74e-14c8d2cbfa45' } }

      it 'returns an appropriate Aux' do
        expect(action).to be_a(Aux::MusicTrack)
      end

      it 'returns a valid Aux' do
        expect(action).to be_valid
      end

      context 'when the track does not exist' do
        let(:opts) { { mbid: 'nonexistent-mbid' } }

        it 'raises an API error' do
          expect { action }.to raise_error(Lastfm::ApiError, 'Track not found')
        end
      end
    end

    context 'with an artist name and track title' do
      let(:opts) { { title: 'Guero', artist_name: 'Beck' } }

      it 'returns an appropriate Aux' do
        expect(action).to be_a(Aux::MusicTrack)
      end

      it 'returns a valid Aux' do
        expect(action).to be_valid
      end

      context 'when the track does not exist' do
        let(:opts) { { title: 'Hopefully this track title will never exist', artist_name: 'Beck' } }

        it 'raises an API error' do
          expect { action }.to raise_error(Lastfm::ApiError, 'Track not found')
        end
      end
    end
  end

  describe '#fetch_music_artist' do
    let(:opts) { {} }
    let(:action) { subject.fetch_music_artist(opts) }

    context 'with an MBID' do
      let(:opts) { { mbid: 'a8baaa41-50f1-4f63-979e-717c14979dfb' } }

      it 'returns an appropriate Aux' do
        expect(action).to be_a(Aux::MusicArtist)
      end

      it 'returns a valid Aux' do
        expect(action).to be_valid
      end

      context 'when the artist does not exist' do
        let(:opts) { { mbid: 'nonexistent-mbid' } }

        it 'raises an API error' do
          expect { action }.to raise_error(Lastfm::ApiError, 'The artist you supplied could not be found')
        end
      end
    end

    context 'with an artist name' do
      let(:opts) { { name: 'Beck' } }

      it 'returns an appropriate Aux' do
        expect(action).to be_a(Aux::MusicArtist)
      end

      it 'returns a valid Aux' do
        expect(action).to be_valid
      end

      context 'when the artist does not exist' do
        let(:opts) { { name: 'Hopefully this artist name will never exist' } }

        it 'raises an API error' do
          expect { action }.to raise_error(Lastfm::ApiError, 'The artist you supplied could not be found')
        end
      end
    end
  end

  describe '#fetch_music_album' do
    let(:opts) { {} }
    let(:action) { subject.fetch_music_album(opts) }

    context 'with an MBID' do
      let(:opts) { { mbid: '4c55abd2-9644-31fb-b73e-6452db131709' } }

      it 'returns an appropriate Aux' do
        expect(action).to be_a(Aux::MusicAlbum)
      end

      it 'returns a valid Aux' do
        expect(action).to be_valid
      end

      context 'when the album does not exist' do
        let(:opts) { { mbid: 'nonexistent-mbid' } }

        it 'raises an API error' do
          expect { action }.to raise_error(Lastfm::ApiError, 'Album not found')
        end
      end
    end

    context 'with an artist name and album title' do
      let(:opts) { { title: 'Guero', artist_name: 'Beck' } }

      it 'returns an appropriate Aux' do
        expect(action).to be_a(Aux::MusicAlbum)
      end

      it 'returns a valid Aux' do
        expect(action).to be_valid
      end

      context 'when the album does not exist' do
        let(:opts) { { title: 'Hopefully this album title will never exist', artist_name: 'Beck' } }

        it 'raises an API error' do
          expect { action }.to raise_error(Lastfm::ApiError, 'Album not found')
        end
      end
    end
  end
end

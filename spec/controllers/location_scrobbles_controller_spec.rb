# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LocationScrobblesController, :vcr do
  describe 'PATCH update' do
    let(:user) { create :user }
    let(:location_scrobble) { create :place_scrobble, user: user }

    let(:action) { patch :update, params: params }

    before { sign_in user }

    context 'setting a place' do
      let(:new_place) { create :place, global: true }
      let(:params) { { id: location_scrobble.id, location_scrobble: { place_id: new_place.id }, format: :js } }

      it 'sets the place' do
        action

        expect(location_scrobble.reload.place).to eq(new_place)
      end

      it 'does not create a new place_match by default' do
        expect { action }.to_not change(PlaceMatch, :count)
      end

      context 'when creating a new place_match' do
        let(:params) do
          {
            id: location_scrobble.id,
            location_scrobble: { place_id: new_place.id },
            place_match: {
              enabled: true,
              source_fields: {
                name: location_scrobble.name,
                latitude: location_scrobble.latitude,
                longitude: location_scrobble.longitude
              }
            },
            format: :js
          }
        end

        it 'creates a new place_match' do
          expect { action }.to change(PlaceMatch, :count).by(1)
        end
      end
    end

    context 'changing a place' do
      let(:old_place) { create :place, global: true }
      let(:new_place) { create :place, global: true }
      let(:location_scrobble) { create :place_scrobble, user: user, place: old_place }
      let(:params) { { id: location_scrobble.id, location_scrobble: { place_id: new_place.id }, format: :js } }

      it 'sets the place' do
        action

        expect(location_scrobble.reload.place).to eq(new_place)
      end

      it 'does not create a new place_match by default' do
        expect { action }.to_not change(PlaceMatch, :count)
      end

      context 'when creating a place_match' do
        let(:params) do
          {
            id: location_scrobble.id,
            location_scrobble: { place_id: new_place.id },
            place_match: {
              enabled: true,
              source_fields: {
                name: location_scrobble.name,
                latitude: location_scrobble.latitude,
                longitude: location_scrobble.longitude
              }
            },
            format: :js
          }
        end

        it 'creates a new place_match' do
          expect { action }.to change(PlaceMatch, :count).by(1)
        end
      end

      context 'with an existing place match' do
        let(:enabled) { true }
        let(:to_delete) { false }
        let(:source_fields) do
          {
            name: location_scrobble.name,
            latitude: location_scrobble.latitude,
            longitude: location_scrobble.longitude
          }
        end

        let(:params) do
          {
            id: location_scrobble.id,
            location_scrobble: { place_id: new_place.id },
            place_match: {
              enabled: enabled,
              to_delete: to_delete,
              source_fields: source_fields
            },
            format: :js
          }
        end

        let!(:existing_place_match) do
          create :place_match, place: old_place, source_fields: source_fields, user: location_scrobble.user
        end

        it 'does not create a new place_match' do
          expect { action }.to_not change(PlaceMatch, :count)
        end

        it 'updates the existing place_match' do
          action

          expect(existing_place_match.reload.place).to eq(new_place)
        end

        context 'when place_match is disabled' do
          let(:enabled) { false }

          it 'does not create a new place_match' do
            expect { action }.to_not change(PlaceMatch, :count)
          end

          it 'does not change the existing place_match' do
            expect { action }.to_not change { existing_place_match.reload.place }
          end
        end
      end
    end
  end
end

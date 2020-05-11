# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LocationScrobblesController, :vcr do
  describe 'PATCH update' do
    let(:user) { create :user }
    let(:location_scrobble) { create :place_scrobble, user: user }

    let(:action) { patch :update, params: params }

    before { sign_in user }

    context 'setting the "singular" state' do
      let(:params) { { id: location_scrobble.id, location_scrobble: { singular: '1' }, format: :js } }

      it 'sets the scrobble as singular' do
        action

        expect(location_scrobble.reload).to be_singular
      end

      context 'when an errant place ID is given' do
        let(:params) do
          {
            id: location_scrobble.id,
            location_scrobble: { singular: '1', place_id: create(:place, global: true).id },
            format: :js
          }
        end

        it 'does not set the place' do
          action

          expect(location_scrobble.reload.place).to be_blank
        end

        it 'sets the scrobble as singular' do
          action

          expect(location_scrobble.reload).to be_singular
        end
      end

      context 'when errant place attributes are given' do
        let(:params) do
          {
            id: location_scrobble.id,
            location_scrobble: { singular: '1', place_attributes: attributes_for(:place) },
            format: :js
          }
        end

        it 'does not create a new place' do
          expect { action }.to_not change(Place, :count)
        end

        it 'does not set the place association' do
          action

          expect(location_scrobble.reload.place).to be_blank
        end

        it 'sets the singular state' do
          action

          expect(location_scrobble.reload).to be_singular
        end
      end
    end

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

      context 'when the singular attribute is given but is false' do
        let(:params) do
          { id: location_scrobble.id, location_scrobble: { place_id: new_place.id, singular: '0' }, format: :js }
        end

        it 'sets the place' do
          action

          expect(location_scrobble.reload.place).to eq(new_place)
        end

        it 'does not set the scrobble to singular' do
          action

          expect(location_scrobble.reload).to_not be_singular
        end
      end

      context 'when passing in errant place attributes' do
        let(:params) do
          {
            id: location_scrobble.id,
            location_scrobble: { place_id: new_place.id, place_attributes: attributes_for(:place) },
            format: :js
          }
        end

        it 'does not create a new Place record' do
          new_place

          expect { action }.to_not change(Place, :count)
        end

        it 'associates the scrobble to the correct record' do
          action

          expect(location_scrobble.reload.place).to eq(new_place)
        end
      end

      context 'when creating a new place_match' do
        let(:params) do
          {
            id: location_scrobble.id,
            location_scrobble: {
              place_id: new_place.id,
              match_options_attributes: {
                enabled: true,
                match_name: true,
                match_coordinates: true
              },
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

      context 'when passing in errant place attributes' do
        let(:params) do
          {
            id: location_scrobble.id,
            location_scrobble: { place_id: new_place.id, place_attributes: attributes_for(:place) },
            format: :js
          }
        end

        it 'does not create a new Place record' do
          old_place
          new_place

          expect { action }.to_not change(Place, :count)
        end

        it 'associates the scrobble to the correct record' do
          action

          expect(location_scrobble.reload.place).to eq(new_place)
        end
      end

      context 'when creating a place_match' do
        let(:params) do
          {
            id: location_scrobble.id,
            location_scrobble: {
              place_id: new_place.id,

              match_options_attributes: {
                enabled: true,
                match_name: true,
                match_coordinates: true
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
        let(:source_field_name) { location_scrobble.name }

        let(:params) do
          {
            id: location_scrobble.id,
            location_scrobble: {
              place_id: new_place.id,
              match_options_attributes: {
                enabled: enabled,
                to_delete: to_delete,
                match_name: true
              },
            },
            format: :js
          }
        end

        let!(:existing_place_match) do
          create :place_match, :name_only,
            place: old_place, source_field_name: source_field_name, user: location_scrobble.user
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

    context 'creating a new place' do
      let(:params) { { id: location_scrobble.id, location_scrobble: { place_attributes: attributes_for(:place) } } }

      it 'creates a new place' do
        expect { action }.to change(Place, :count).by(1)
      end

      it 'associates the new place' do
        action

        expect(location_scrobble.reload.place).to be_present
      end
    end

    context 'updating an existing place' do
      let(:old_place) { create :place, global: true }
      let(:location_scrobble) { create :place_scrobble, user: user, place: old_place }

      let(:params) do
        {
          id: location_scrobble.id,

          location_scrobble: {
            place_id: old_place.id,
            place_attributes: old_place.attributes.merge('name' => 'New name')
          },

          format: :js
        }
      end

      it 'does not create a new place' do
        old_place

        expect { action }.to_not change(Place, :count)
      end

      it 'updates the place correctly' do
        action

        expect(location_scrobble.reload.place.name).to eq('New name')
      end
    end
  end
end

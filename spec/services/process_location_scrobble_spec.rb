# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProcessLocationScrobble do
  let(:options) { { save: true } }

  let(:location_scrobble) { build :place_scrobble }

  subject { ProcessLocationScrobble }

  describe '#call' do
    let(:action) { subject.(location_scrobble, **options) }

    it 'saves the location_scrobble' do
      action

      expect(location_scrobble).to be_persisted
    end

    it 'is successful when everything is valid' do
      expect(action).to be_success
    end

    context 'when the save option is false' do
      let(:options) { { save: false } }

      it 'does not save the location_scrobble' do
        action

        expect(location_scrobble).to_not be_persisted
      end

      it 'is nevertheless successful' do
        expect(action).to be_success
      end
    end

    context 'when the location_scrobble is a transit_scrobble' do
      let(:location_scrobble) { build :transit_scrobble }

      it 'is successful' do
        expect(action).to be_success
      end
    end

    describe 'collision modes' do
      let!(:overlapping_location_scrobble) do
        create :place_scrobble, user: location_scrobble.user, start_time: 5.hours.ago, end_time: 4.hours.ago
      end
      let!(:non_overlapping_location_scrobble) do
        create :place_scrobble, user: location_scrobble.user, start_time: 9.hours.ago, end_time: 8.hours.ago
      end
      let(:location_scrobble) { build :place_scrobble, start_time: 5.5.hours.ago, end_time: 4.5.hours.ago }

      context 'default' do
        let(:options) { { save: true, collision_mode: :default } }

        it 'saves the location_scrobble' do
          action

          expect(location_scrobble).to be_persisted
        end

        it 'keeps the existing overlap around' do
          action

          expect { overlapping_location_scrobble.reload }.to_not raise_error
        end

        it 'keeps the non-overlapping scrobble around' do
          action

          expect { non_overlapping_location_scrobble.reload }.to_not raise_error
        end
      end

      context 'overwrite' do
        let(:options) { { save: true, collision_mode: :overwrite } }

        it 'saves the location_scrobble' do
          action

          expect(location_scrobble).to be_persisted
        end

        it 'destroys the overlapping location_scrobble' do
          action

          expect { overlapping_location_scrobble.reload }.to raise_error(ActiveRecord::RecordNotFound)
        end

        it 'does not destroy the non-overlapping scrobble' do
          action

          expect { non_overlapping_location_scrobble.reload }.to_not raise_error
        end
      end

      context 'skip' do
        let(:options) { { save: true, collision_mode: :skip } }

        it 'does not save the location_scrobble' do
          action

          expect(location_scrobble).to_not be_persisted
        end

        it 'keeps the existing overlap around' do
          action

          expect { overlapping_location_scrobble.reload }.to_not raise_error
        end

        it 'keeps the non-overlapping scrobble around' do
          action

          expect { non_overlapping_location_scrobble.reload }.to_not raise_error
        end
      end
    end
  end
end

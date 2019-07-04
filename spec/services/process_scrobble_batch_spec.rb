# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProcessScrobbleBatch do
  let(:source) { create :scrobbler }
  let(:scrobbles) { build_list :point_scrobble, 3, timestamp: 3.hours.ago, source: source }
  let!(:batch) { ScrobbleBatch.new(scrobbles: scrobbles, start_time: 7.hours.ago, end_time: 1.hour.ago) }

  let!(:existing_overlapping_scrobble) { create :point_scrobble, timestamp: 4.hours.ago, source: source }
  let!(:existing_non_overlapping_scrobble) { create :point_scrobble, timestamp: 10.hours.ago, source: source }

  shared_examples 'an unsuccessful batch process' do
    it 'fails' do
      expect(ProcessScrobbleBatch.(batch)).to_not be_success
    end

    it 'does not persist any scrobbles' do
      ProcessScrobbleBatch.(batch)

      expect(scrobbles.any?(&:persisted?)).to be(false)
    end

    it 'does not destroy overlapping scrobbles' do
      ProcessScrobbleBatch.(batch)

      expect { existing_overlapping_scrobble.reload }.to_not raise_error
    end

    it 'keeps the counter cache the same' do
      ProcessScrobbleBatch.(batch)

      expect(source.scrobbles_count).to eq(2)
    end

    it 'adds an error to the result' do
      expect(ProcessScrobbleBatch.(batch).errors).to be_present
    end
  end

  it 'is successful when given valid input' do
    expect(ProcessScrobbleBatch.(batch)).to be_success
  end

  it 'destroys overlapping scrobbles' do
    ProcessScrobbleBatch.(batch)

    expect { existing_overlapping_scrobble.reload }.to raise_error(ActiveRecord::RecordNotFound)
  end

  it 'does not destroy non-overlapping scrobbles' do
    ProcessScrobbleBatch.(batch)

    expect { existing_non_overlapping_scrobble.reload }.to_not raise_error
  end

  it 'persists the given records' do
    expect(scrobbles.any?(&:persisted?)).to be(false) # sanity check

    ProcessScrobbleBatch.(batch)

    expect(scrobbles.all?(&:persisted?)).to be(true)
  end

  it 'updates the counter cache on the source' do
    ProcessScrobbleBatch.(batch)

    expect(source.scrobbles_count).to eq(4)
  end

  context 'when the batch is empty', :skip do # TODO
    let(:scrobbles) { [] }

    it 'does not fail' do
      expect(ProcessScrobbleBatch.(batch)).to be_success
    end
  end

  context 'when the batch contains errors' do
    before { allow(batch).to receive(:success?).and_return(false) }

    it_behaves_like 'an unsuccessful batch process'
  end

  context 'when the batch contains invalid scrobbles' do
    before do
      scrobbles.first.category = nil
      expect(scrobbles.first).to_not be_valid # sanity check
    end

    it_behaves_like 'an unsuccessful batch process'
  end

  context 'when not all scrobbles in the batch belong to the same source' do
    before do
      scrobbles.first.source = create(:scrobbler)
    end

    it_behaves_like 'an unsuccessful batch process'
  end
end

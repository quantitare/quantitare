# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ScrobblerCheckJob do
  let(:result) { double 'result', success?: true }
  let(:processor) { class_double('ProcessScrobbleBatch', call: result) }
  let(:batch) { instance_double(ScrobbleBatch, start_time: 2.hours.ago, end_time: 1.hour.ago) }
  let(:scrobbler) { create :scrobbler, service: create(:service) }

  describe '#perform' do
    let(:action) { ScrobblerCheckJob.perform_now(scrobbler, Scrobbler::CHECK_SHALLOW, processor: processor) }

    before do
      allow(scrobbler).to receive(:run_check).with(Scrobbler::CHECK_SHALLOW).and_yield(batch)
    end

    it 'calls run_check on the scrobbler' do
      expect(scrobbler).to receive(:run_check).with(Scrobbler::CHECK_SHALLOW).and_yield(batch)

      action
    end

    it 'calls the processor with the batch' do
      expect(processor).to receive(:call).with(batch).and_return(result)

      action
    end

    context 'when the service is having issues' do
      before do
        allow(scrobbler).to receive(:service_issues?).and_return(true)
      end

      it 'does not run the check' do
        expect(processor).to_not receive(:call)

        action
      end

      it 'does not enqueue any jobs' do
        expect { action }.to_not change(ScrobblerCheckJob._queue_adapter.enqueued_jobs, :size)
      end
    end

    context 'when the batch import fails' do
      let(:result) { double 'result', success?: false }

      it 'enqueues a ScrobblerFetchJob' do
        expect { action }.to change(ScrobblerCheckJob._queue_adapter.enqueued_jobs, :size).by(1)
      end
    end
  end

  describe 'interface contracts' do
    specify { expect(scrobbler).to respond_to(:run_check).with(1).argument }
    specify { expect(scrobbler).to respond_to(:service_issues?) }
  end
end

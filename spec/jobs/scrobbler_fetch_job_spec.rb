# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ScrobblerFetchJob do
  let(:result) { double 'result', success?: true }
  let(:processor) { class_double('ProcessScrobbleBatch', call: result) }
  let(:scrobbler) { create :scrobbler, service: create(:service) }

  let(:action) { ScrobblerFetchJob.perform_now(scrobbler, 2.hours.ago, 1.hour.ago, processor: processor) }

  before do
    allow(scrobbler).to receive(:fetch_and_format_scrobbles).and_return([instance_double(Scrobble)])
  end

  describe '#perform' do
    it 'calls #fetch_and_format_scrobbles on the scrobbler' do
      expect(scrobbler).to receive(:fetch_and_format_scrobbles).and_return([instance_double(Scrobble)])

      action
    end

    it 'calls the processor' do
      expect(processor).to receive(:call).with(kind_of ScrobbleBatch).and_return(result)

      action
    end

    context 'when fetching scrobbles raises a config error' do
      before { allow(scrobbler).to receive(:fetch_and_format_scrobbles).and_raise(Errors::ServiceConfigError) }

      it 'does not call the processor' do
        expect(processor).to_not receive(:call)

        action
      end

      it 'reports an issue to the service' do
        expect(scrobbler.service).to_not be_issues # sanity check

        action

        expect(scrobbler.service).to be_issues
      end
    end

    context 'when fetching scrobbles raises an API error' do
      before { allow(scrobbler).to receive(:fetch_and_format_scrobbles).and_raise(Errors::ServiceAPIError) }

      it 'does not call the processor' do
        expect(processor).to_not receive(:call)

        begin
          action
        rescue Errors::ServiceAPIError
        end
      end

      it 'raises the error out of the job' do
        expect { action }.to raise_error(Errors::ServiceAPIError)
      end
    end

    context 'when batch processing raises an error' do
      let(:result) { double 'result', success?: false, errors: [] }

      it 'raises an appropriate error' do
        expect { action }.to raise_error(Errors::ScrobbleBatchError)
      end
    end
  end

  describe 'interface contracts' do
    specify { expect(scrobbler).to respond_to(:fetch_and_format_scrobbles).with(2).arguments }
  end
end

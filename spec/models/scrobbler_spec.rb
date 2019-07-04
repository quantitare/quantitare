require 'rails_helper'

RSpec.describe Scrobbler do
  subject { create(:scrobbler) }

  describe '#source_identifier' do
    it "contains the scrobbler's ID" do
      expect(subject.source_identifier).to include(subject.id.to_s)
    end

    it "contains the scrobbler's type" do
      expect(subject.source_identifier).to include(subject.type)
    end
  end

  describe '#run_check' do
    context 'when the fetch_in_chunks flag is not set' do
      before { allow(subject).to receive(:fetch_in_chunks?).and_return(false) }

      it 'fetches everything in a single batch' do
        expect(subject).to receive(:collect_scrobbles).once.and_call_original

        subject.run_check(subject.class::CHECK_DEEP)
      end

      it 'yields to the block once' do
        callee = spy('callee')

        subject.run_check(subject.class::CHECK_DEEP) { |batch| callee.(batch) }

        expect(callee).to have_received(:call).once.with(kind_of ScrobbleBatch)
      end
    end

    context 'when the fetch_in_chunks flag is set' do
      before { allow(subject).to receive(:fetch_in_chunks?).and_return(true) }

      it 'fetches everything in multiple batches' do
        expect(subject).to receive(:collect_scrobbles).at_least(:twice).and_call_original

        subject.run_check(subject.class::CHECK_DEEP)
      end

      it 'yields to the block multiple times' do
        callee = spy('callee')

        subject.run_check(subject.class::CHECK_DEEP) { |batch| callee.(batch) }

        expect(callee).to have_received(:call).at_least(:twice).with(kind_of ScrobbleBatch)
      end
    end

    it 'raises a CheckNotFound error with an invalid check' do
      expect { subject.run_check('some nonsense') }.to raise_error(subject.class::CheckNotFound)
    end
  end

  describe '#collect_scrobbles_in_chunks' do
    it 'calls #collect_scrobbles once for each chunk covered by the start_time and end_time' do
      expect(subject).to receive(:collect_scrobbles).exactly(3).times.and_call_original

      subject.collect_scrobbles_in_chunks(3.weeks.ago, 1.hour.ago)
    end

    it 'yields to the block once for each iteration' do
      callee = spy('callee')

      subject.collect_scrobbles_in_chunks(4.weeks.ago, 1.hour.ago) { |batch| callee.(batch) }

      expect(callee).to have_received(:call).exactly(4).times.with(kind_of ScrobbleBatch)
    end
  end

  describe '#collect_scrobbles' do
    let(:action) { subject.collect_scrobbles(4.hours.ago, 1.hour.ago) }

    it 'calls #fetch_scrobbles on self' do
      expect(subject).to receive(:fetch_scrobbles).and_call_original

      action
    end

    it 'returns a successful batch' do
      expect(action).to be_success
    end

    it 'yields to the block' do
      callee = spy('callee')

      subject.collect_scrobbles(4.hours.ago, 1.hour.ago) { |batch| callee.(batch) }

      expect(callee).to have_received(:call).with(kind_of ScrobbleBatch)
    end

    context 'when the fetch raises an expected error' do
      before { allow(subject).to receive(:fetch_scrobbles).and_raise(Errors::ServiceConfigError) }

      it 'returns an unsuccessful batch' do
        expect(action).to_not be_success
      end
    end
  end

  describe '#fetch_scrobbles' do
    subject { Scrobbler.new }

    it 'raises an error if not implemented in a subclass' do
      expect { subject.fetch_scrobbles(nil, nil) }.to raise_error(NotImplementedError)
    end
  end

  describe '#create_scrobble' do
    let(:action) { subject.create_scrobble(scrobble) }

    context 'when the input is a hash do' do
      let(:scrobble) do
        { category: 'log', timestamp: Faker::Time.backward(14, :day), data: { content: 'some content' } }
      end

      it 'creates a new scrobble' do
        expect { action }.to change(Scrobble, :count).by(1)
      end

      it 'returns a Scrobble object' do
        expect(action).to be_a(Scrobble)
      end

      it "sets the scrobble's user" do
        expect(action.user).to eq(subject.user)
      end

      it "sets the scrobble's source" do
        expect(action.source).to eq(subject)
      end
    end

    context 'when the input is a Scrobble' do
      let(:scrobble) { Scrobble.new(category: 'log', timestamp: 5.days.ago, data: { content: 'some content' }) }

      it 'saves the scrobble' do
        expect(scrobble).to_not be_persisted # sanity check

        action

        expect(scrobble).to be_persisted
      end

      it 'sets the source to self' do
        action

        expect(scrobble.source).to eq(subject)
      end

      it "sets the scrobble's user" do
        action

        expect(scrobble.user).to eq(subject.user)
      end
    end
  end

  describe '#handle_webhook' do
    it 'returns a 404 status' do
      expect(subject.handle_webhook(nil).status).to eq(404)
    end
  end
end

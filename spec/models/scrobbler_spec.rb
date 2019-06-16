require 'rails_helper'

RSpec.describe Scrobbler do
  subject { create(:scrobbler) }

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
end

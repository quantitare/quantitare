require 'rails_helper'

RSpec.describe ArcGPXAdapter::BundledAttributes do
  let(:placemarks) do
    [
      double(
        'mark1', name: 'foo', type: 'world', category: 'whatever', description: 'a description 1', distance: 1,
        trackpoints: [double('trk_a', timestamp: 60.minutes.ago), double('trk_b', timestamp: 55.minutes.ago)]
      ),

      double(
        'mark2', name: 'bar', type: 'hello', category: 'whatever', description: 'a description 2', distance: 2,
        trackpoints: [double('trk_c', timestamp: 65.minutes.ago)]
      ),

      double(
        'mark3', name: 'foo', type: 'hello', category: 'dudeeeee', description: 'a description 3', distance: 3,
        trackpoints: [double('trk_d', timestamp: 70.minutes.ago), double('trk_e', timestamp: 50.minutes.ago)]
      )
    ]
  end
  let(:bundle) { double 'bundle', placemarks: placemarks }

  subject { ArcGPXAdapter::BundledAttributes.new(bundle) }

  describe '#name' do
    it 'returns the prevailing name' do
      expect(subject.name).to eq('foo')
    end

    context 'when there are a lot of nils' do
      let(:placemarks) do
        [
          double('mark1', name: nil),
          double('mark2', name: nil),
          double('mark3', name: 'foo')
        ]
      end

      it 'returns the prevailing non-blank name' do
        expect(subject.name).to eq('foo')
      end
    end
  end

  describe '#type' do
    it 'returns the prevailing type' do
      expect(subject.type).to eq('hello')
    end
  end

  describe '#category' do
    it 'returns the prevailing category' do
      expect(subject.category).to eq('whatever')
    end
  end

  describe '#description' do
    it 'returns the first non-blank description' do
      expect(subject.description).to eq('a description 1')
    end

    context "then they're all blank" do
      let(:placemarks) do
        [
          double('mark1', description: nil),
          double('mark2', description: nil)
        ]
      end

      it 'returns a blank attribute' do
        expect(subject.description).to be_blank
      end
    end
  end

  describe '#distance' do
    it 'returns the sum of all the distances' do
      expect(subject.distance).to eq(6)
    end

    context 'when there are blank/nil distances' do
      let(:placemarks) do
        [
          double('mark1', distance: 2),
          double('mark2', distance: 5),
          double('mark3', distance: nil)
        ]

        it 'does not error out and returns the sum' do
          expect(subject.distance).to eq(5)
        end
      end
    end
  end

  describe '#trackpoints' do
    it 'returns the concatenated trackpoints' do
      expect(subject.trackpoints.length).to eq(5)
    end

    it 'sorts the trackpoints by time' do
      expect(subject.trackpoints).to eq(subject.trackpoints.sort_by(&:timestamp))
    end
  end
end

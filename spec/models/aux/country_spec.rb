require 'rails_helper'

RSpec.describe Aux::Country do
  describe '.all' do
    it 'returns an enumerable' do
      expect(Aux::Country.all).to respond_to(:each)
    end

    it 'has Aux::Country objects' do
      expect(Aux::Country.all.all? { |country| country.is_a?(Aux::Country) }).to be(true)
    end
  end

  describe '.coded' do
    it 'returns an Aux::Country when it exists' do
      expect(Aux::Country.coded('HU')).to be_a(Aux::Country)
    end

    it 'returns nil when it cannot find a country' do
      expect(Aux::Country.coded('ZZ')).to be_nil
    end
  end

  describe '.named' do
    it 'returns an Aux::Country when it exists' do
      expect(Aux::Country.named('Hungary')).to be_a(Aux::Country)
    end

    it 'returns nil when it cannot find a country' do
      expect(Aux::Country.named('This country will hopefully never exist!')).to be_nil
    end
  end

  describe '#code' do
    it 'returns the right string' do
      expect(Aux::Country.named('Hungary').code).to eq('HU')
    end
  end

  describe '#subregions' do
    it 'returns an enumerable' do
      expect(Aux::Country.coded('HU').subregions).to respond_to(:each)
    end

    it 'has Aux::Region objects' do
      expect(Aux::Country.coded('HU').subregions.all? { |region| region.is_a?(Aux::Region) }).to be(true)
    end
  end
end

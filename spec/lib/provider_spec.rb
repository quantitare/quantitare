require 'rails_helper'

RSpec.describe Provider do
  describe '.oauth_providers' do
    it 'is an array' do
      expect(Provider.oauth_providers).to be_an(Array)
    end
  end

  describe '.non_oauth_providers' do
    it 'is an array' do
      expect(Provider.non_oauth_providers).to be_an(Array)
    end
  end

  describe '.non_oauth_provider_names' do
    it 'is an array of strings' do
      expect(Provider.non_oauth_provider_names.all? { |el| el.is_a?(String) }).to be(true)
    end
  end

  describe '.all' do
    it 'is an array' do
      expect(Provider.all).to be_an(Array)
    end
  end

  describe '.names' do
    it 'is an array' do
      expect(Provider.names).to be_an(Array)
    end
  end

  describe '#icon' do
    it 'is an Icon instance' do
      expect(Provider.all.first.icon).to be_an(Icon)
    end
  end
end

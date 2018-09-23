require 'rails_helper'

RSpec.describe Aux::Region do
  let(:coded_region) { Carmen::Country.coded('US').subregions.coded('CA') }

  describe '#name' do
    it 'returns the right name' do
      expect(Aux::Region.new(coded_region).name).to eq('California')
    end
  end
end

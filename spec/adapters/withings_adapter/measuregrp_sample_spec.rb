# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WithingsAdapter::MeasuregrpSample do
  subject do
    WithingsAdapter::MeasuregrpSample.new(
      'the_category',
      {
        "grpid" => 1503355193,
        "attrib" => 2,
        "date" => 1561920872,
        "created" => 1561920874,
        "category" => 1,
        "deviceid" => nil,
        "measures" => [
          { "value" => 63593, "type" => 1, "unit" => -3, "algo" => 0, "fw" => 0, "fm" => 3 },
          { "value" => 11111, "type" => 2, "unit" => -1, "algo" => 0, "fw" => 0, "fm" => 3 }
        ],
        "comment" => nil
      },
      { key: 'kg', type: 1 }
    )
  end

  describe '#to_scrobble' do
    let(:action) { subject.to_scrobble }

    it 'returns a list' do
      expect(action).to be_an(Array)
    end

    it 'excludes the measures that do not belong to the given type' do
      expect(action.length).to eq(1)
    end

    it 'sets the proper value' do
      expect(action.first.data['kg']).to eq(63593.to_f * 10**-3)
    end

    it 'sets the category' do
      expect(action.first.category).to eq('the_category')
    end

    it 'sets the proper timestamp' do
      expect(action.first.timestamp).to eq(Time.zone.at(1561920872))
    end
  end
end

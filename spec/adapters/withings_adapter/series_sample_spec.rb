# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WithingsAdapter::SeriesSample do
  subject do
    WithingsAdapter::SeriesSample.new(
      'category',
      1.hour.ago,
      { "steps" => 41, "elevation" => 0, "calories" => 1.165 },
      { fields: [{ key: 'count', value: 'steps' }, { key: 'calories', value: 'calories' }] }
    )
  end

  describe '#to_scrobble' do
    let(:action) { subject.to_scrobble }

    it 'sets the proper data' do
      expect(action.data['count']).to eq(41)
    end

    it 'pulls from multiple fields' do
      expect(action.data['calories']).to eq(1.165)
    end
  end
end

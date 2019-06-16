# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PointScrobble do
  subject { build :point_scrobble }

  it_behaves_like Scrobble

  describe 'validations' do
    it 'is not valid if start_time and end_time are different' do
      subject.start_time = Time.now
      subject.end_time = 10.years.ago

      expect(subject).to_not be_valid
    end
  end
end

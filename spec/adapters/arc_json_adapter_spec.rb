# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ArcJSONAdapter, vcr: { match_requests_on: [:method, :host] } do
  let(:file) { file_fixture('arc_json_import.json').read }
  subject { ArcJSONAdapter.new(file) }

  before do
    allow(Place).to receive(:fetch) { create :place }
  end

  it_behaves_like LocationImportable

  describe '#location_scrobbles' do
    it 'returns a list of LocationScrobble records' do
      expect(subject.location_scrobbles.all? { |ele| ele.is_a?(LocationScrobble) }).to be(true)
    end

    it 'returns a list of unpersisted LocationScrobble records' do
      expect(subject.location_scrobbles.any?(&:persisted?)).to be(false)
    end
  end
end

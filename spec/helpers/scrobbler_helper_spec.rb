# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ScrobblerHelper do
  let(:scrobbler) { create :withings_scrobbler }

  before { sign_in(create :user) }

  describe '#type_options_for_scrobbler' do
    it 'returns an array of hashes' do
      expect(helper.type_options_for_scrobbler(scrobbler).all? { |item| item.is_a?(Hash) }).to be(true)
    end
  end

  describe '#scrobbler_provider_options' do
    it 'returns an array of hashes' do
      expect(helper.scrobbler_provider_options(scrobbler).all? { |item| item.is_a?(Hash) }).to be(true)
    end
  end

  describe '#scrobbler_status_badge' do
    it 'has a "success" class when the scrobbler is working' do
      allow(scrobbler).to receive(:working?).and_return(true)

      expect(helper.scrobbler_status_badge(scrobbler)).to include('success')
    end

    it 'has a "danger" class when the scrobbler is not working' do
      allow(scrobbler).to receive(:working?).and_return(false)

      expect(helper.scrobbler_status_badge(scrobbler)).to include('danger')
    end
  end

  describe '#scrobbler_schedule_options' do
    it 'returns an array of arrays' do
      expect(helper.scrobbler_schedule_options(scrobbler).all? { |item| item.is_a?(Array) }).to be(true)
    end
  end

  describe 'interface contracts' do
    specify { expect(scrobbler).to respond_to(:working?).with(0).arguments }
  end
end

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RescuetimeAdapter, :vcr do
  let(:service) { create :service, :rescuetime }

  subject { RescuetimeAdapter.new(service) }

  before do
    @previous_time_zone = Time.zone
    Time.zone = 'US/Pacific'
  end

  after do
    Time.zone = @previous_time_zone
  end

  describe '#fetch_scrobbles' do
    let(:action) do
      subject.fetch_scrobbles(Time.zone.parse('2019-07-05').to_date, Time.zone.parse('2019-07-08').to_date)
    end

    it 'raises a config error if the credentials are invalid' do
      service.token = 'some_nonsense'

      expect { action }.to raise_error(Errors::ServiceConfigError)
    end

    it 'raises a config error if the credentials are missing' do
      service.token = nil

      expect { action }.to raise_error(Errors::ServiceConfigError)
    end

    it 'raises a config error if an invalid request is sent' do
      expect { subject.fetch_scrobbles('abcd', '') }.to raise_error(Errors::ServiceConfigError)
    end

    it 'raises an API error if the client gets rate limited' do
      expect { action }.to raise_error(Errors::ServiceAPIError)
    end

    it 'returns an array if successful' do
      expect(action).to be_an(Array)
    end

    it 'returns an array of Scrobble objects' do
      expect(action.all? { |item| item.is_a?(::Scrobble) }).to be(true)
    end

    it 'returns everything unpersisted' do
      expect(action.none? { |item| item.persisted? }).to be(true)
    end

    it 'has start_times and end_times for each returned scrobble' do
      expect(action.all? { |item| item.start_time.present? && item.end_time.present? }).to be(true)
    end

    it 'returns valid data for each returned scrobble' do
      expect(
        action.all? do |item|
          item.validate
          item.errors[:data].blank?
        end
      ).to be(true)
    end

    it 'returns nothing when all returned scrobbles are out of range' do
      result = subject.fetch_scrobbles(Time.zone.parse('2005-07-05').to_date, Time.zone.parse('2005-07-08').to_date)

      expect(result).to be_blank
    end
  end
end

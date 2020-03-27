# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FlickrAdapter, vcr: { match_requests_on: [:method, :uri, :body] } do
  let(:service) { create :service, :flickr }

  subject { FlickrAdapter.new(service) }

  around do |example|
    previous_time_zone = Time.zone
    Time.zone = 'America/Los_Angeles'

    example.run

    Time.zone = previous_time_zone
  end

  describe '#fetch_scrobbles' do
    let(:start_time) { Time.zone.parse('2019-05-01') }
    let(:end_time) { Time.zone.parse('2020-03-01') }
    let(:action) { subject.fetch_scrobbles start_time, end_time }

    it 'returns a list' do
      expect(action).to be_an(Array)
    end

    it 'returns a list of Scrobble objects' do
      expect(action.all? { |item| item.is_a?(Scrobble) }).to be(true)
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

    it 'returns all scrobbles between the specified times' do
      expect(action.all? { |item| item.timestamp.in?(start_time..end_time) }).to be(true)
    end

    it 'throws a config error if the response returns the proper error code' do
      expect { action }.to raise_error(Errors::ServiceConfigError)
    end

    it 'throws an API error if the response terms the proper error code' do
      expect { action }.to raise_error(Errors::ServiceAPIError)
    end
  end
end

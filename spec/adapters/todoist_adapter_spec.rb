# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TodoistAdapter, :vcr do
  let(:service) { create :service, :todoist }

  subject { TodoistAdapter.new(service) }

  describe '#fetch_scrobbles' do
    let(:action) do
      subject.fetch_scrobbles(Time.zone.parse('2019-07-18 00:00:00'), Time.zone.parse('2019-07-19 00:00:00'))
    end

    it 'returns a non-blank list' do
      expect(action).to_not be_blank
    end

    it 'returns a list of scrobbles' do
      expect(action.all? { |item| item.is_a?(::Scrobble) }).to be(true)
    end

    it 'returns a list of scrobbles with valid data' do
      expect(
        action.all? do |item|
          item.validate
          item.errors[:data].blank?
        end
      ).to be(true)
    end

    it 'returns a list of scrobbles timestamped between the designated times' do
      expect(
        action.all? do |item|
          item.timestamp.between?(Time.zone.parse('2019-07-18 00:00:00'), Time.zone.parse('2019-07-19 00:00:00'))
        end
      ).to be(true)
    end

    it 'raises an API error when there is a timeout' do
      allow(subject.client).to receive(:misc_completed).and_raise(Net::OpenTimeout)

      expect { action }.to raise_error(Errors::ServiceAPIError)
    end

    it 'raises a config error when the API returns a 4xx error on the initial request' do
      allow(subject.client).to receive(:misc_completed).and_raise(StandardError.new('HTTP 400 Error - foobar'))

      expect { action }.to raise_error(Errors::ServiceConfigError)
    end

    it 'raises an API error when the API returns a 5xx error on the initial request' do
      allow(subject.client).to receive(:misc_completed).and_raise(StandardError.new('HTTP 500 Error - foobar'))

      expect { action }.to raise_error(Errors::ServiceAPIError)
    end

    it 'passes the error through if some other error is raised' do
      allow(subject.client).to receive(:misc_completed).and_raise(StandardError.new('Some other error'))

      expect { action }.to raise_error(StandardError)
    end

    it 'does not raise an error when the task fetch raises an error' do
      allow(subject.client).to receive(:misc_items).and_raise(StandardError.new('HTTP 400 Error - foobar'))

      expect { action }.to_not raise_error
    end
  end

  describe '#fetch_label' do
    it 'returns an object that responds to #name' do
      expect(subject.fetch_label(id: 2150056338)).to respond_to(:name)
    end

    it 'calls the API just once for subsequent requests' do
      expect(subject).to receive(:client).once.and_call_original

      subject.fetch_label(id: 2152895999)
      subject.fetch_label(id: 2150056338)
    end
  end
end

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TraktAdapter, :vcr do
  let(:service) { create :service, :trakt }

  subject { TraktAdapter.new(service) }

  describe '#fetch_scrobbles' do
    let(:action) do
      subject.fetch_scrobbles(Time.zone.parse('2019-02-01 00:00:00 UTC'), Time.zone.parse('2019-02-15 00:00:00 UTC'))
    end

    it 'fetches a list' do
      expect(action).to respond_to(:each)
    end

    it 'returns all scrobbles' do
      expect(action.all? { |item| item.is_a?(::Scrobble) }).to be(true)
    end

    it 'returns scrobbles with valid data' do
      expect(action.all? do |item|
        item.validate
        item.errors[:data].blank?
      end).to be(true)
    end

    it 'returns scrobbles that have a category' do
      expect(action.all? { |item| item.category.present? }).to be(true)
    end

    it 'returns scrobbles that have a timestamp' do
      expect(action.all? { |item| item.timestamp.present? }).to be(true)
    end

    it 'raises an API error if we are rate limited' do
      expect { action }.to raise_error(Errors::ServiceAPIError)
    end

    it 'raises a config error if we get a 4xx error' do
      expect { action }.to raise_error(Errors::ServiceConfigError)
    end

    it 'raises an API error if we get a 5xx error' do
      expect { action }.to raise_error(Errors::ServiceAPIError)
    end

    context 'when the token is invalid' do
      let(:service) { create :service, :trakt, token: 'some_nonsense' }

      it 'raises a config error' do
        expect { action }.to raise_error(Errors::ServiceConfigError)
      end
    end

    context 'when the user token is expired' do
      let(:service) { create :service, :trakt, :expired }

      it 'is successful' do
        expect { action }.to_not raise_error
      end

      it "refreshes the service's token" do
        expect { action }.to change(subject.service, :token)
      end

      it "refreshes the service's refresh token" do
        expect { action }.to change(subject.service, :refresh_token)
      end
    end
  end
end

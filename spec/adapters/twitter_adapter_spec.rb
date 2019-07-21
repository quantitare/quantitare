# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TwitterAdapter, :vcr do
  let(:service) { create :service, :twitter }

  subject { TwitterAdapter.new(service) }

  describe '#fetch_scrobbles' do
    let(:action) do
      subject.fetch_scrobbles(Time.zone.parse('2019-07-20 00:00:00'), Time.zone.parse('2019-07-23 00:00:00'))
    end

    it 'returns a non-empty list' do
      expect(action).to_not be_empty
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

    context 'when there is something wrong with the user token' do
      let(:service) { create :service, :twitter, token: 'some_nonsense' }

      it 'raises a config error' do
        expect { action }.to raise_error(Errors::ServiceConfigError)
      end
    end

    context 'when paging is required' do
      let(:action) do
        subject.fetch_scrobbles(Time.zone.parse('2014-07-20 00:00:00'), Time.zone.parse('2019-07-23 00:00:00'))
      end

      it 'returns a non-empty list' do
        expect(action).to_not be_empty
      end

      it 'returns a list of unique scrobbles' do
        expect(action.to_set.length).to eq(action.length)
      end
    end

    context 'with a stubbed client' do
      let(:client) { instance_double(Twitter::REST::Client, user_timeline: []) }

      before do
        allow(subject).to receive(:client).and_return(client)
      end

      it 'raises a config error when there is something wrong with the request format' do
        allow(client).to receive(:user_timeline).and_raise(Twitter::Error::BadRequest)

        expect { action }.to raise_error(Errors::ServiceConfigError)
      end

      it 'raises a config error when there is a general error' do
        allow(client).to receive(:user_timeline).and_raise(Twitter::Error::NotFound)

        expect { action }.to raise_error(Errors::ServiceConfigError)
      end

      it 'raises an API error when we are rate limited' do
        allow(client).to receive(:user_timeline).and_raise(Twitter::Error::TooManyRequests)

        expect { action }.to raise_error(Errors::ServiceAPIError)
      end

      it 'raises an API error when there is a 5xx response' do
        allow(client).to receive(:user_timeline).and_raise(Twitter::Error::InternalServerError)

        expect { action }.to raise_error(Errors::ServiceAPIError)
      end
    end
  end
end

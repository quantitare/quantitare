# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WithingsAdapter::ResponseVerifier do
  describe '#process!' do
    subject { WithingsAdapter::ResponseVerifier.new(response) }

    context 'when the response has a 4xx status' do
      let(:response) { instance_double Faraday::Response, success?: false, status: 404 }

      it 'raises a config error' do
        expect { subject.process! }.to raise_error(Errors::ServiceConfigError)
      end
    end

    context 'when the reponse has a 5xx status' do
      let(:response) { instance_double Faraday::Response, success?: false, status: 500 }

      it 'raises an API error' do
        expect { subject.process! }.to raise_error(Errors::ServiceAPIError)
      end
    end

    context 'when the response has a weird status' do
      let(:response) { instance_double Faraday::Response, success?: false, status: 10000 }

      it 'raises an API error' do
        expect { subject.process! }.to raise_error(Errors::ServiceAPIError)
      end
    end

    context 'when the body status is zero' do
      let(:response) { instance_double Faraday::Response, success?: true, body: { 'status' => 0 } }

      it 'does not raise anything' do
        expect { subject.process! }.to_not raise_error
      end
    end

    context 'when the body status is non-fatal' do
      let(:response) do
        instance_double Faraday::Response, success?: true, body: { 'status' => 511, 'message' => 'Timeout' }
      end

      it 'raies an API error' do
        expect { subject.process! }.to raise_error(Errors::ServiceAPIError)
      end
    end

    context 'when the body status is fatal' do
      let(:response) do
        instance_double Faraday::Response, success?: true, body: { 'status' => 1, 'message' => 'Params' }
      end

      it 'raises a config error' do
        expect { subject.process! }.to raise_error(Errors::ServiceConfigError)
      end
    end
  end
end

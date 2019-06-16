require 'rails_helper'

RSpec.describe Scrobblers::WebhookScrobbler do
  let(:scrobbler) { create(:webhook_scrobbler, options: { token: 'foobar' }) }
  let(:payload) { { token: 'foobar' } }
  let(:request_method) { 'POST' }
  let(:request) do
    ActionDispatch::Request.new(
      'action_dispatch.request.request_parameters' => payload,
      'REQUEST_METHOD' => request_method,
      'HTTP_ACCEPT' => 'application/json'
    )
  end

  describe '#handle_webhook' do
    it 'returns an OK status' do
      expect(scrobbler.handle_webhook(request).status).to eq(200)
    end

    context 'when the token does not match' do
      let(:payload) { { token: 'nottherightone' } }

      it 'returns 4xx' do
        expect(scrobbler.handle_webhook(request).status).to eq(401)
      end
    end

    context 'when the request method does not match' do
      let(:request_method) { 'GET' }

      it 'returns 4xx' do
        expect(scrobbler.handle_webhook(request).status).to eq(401)
      end
    end
  end
end

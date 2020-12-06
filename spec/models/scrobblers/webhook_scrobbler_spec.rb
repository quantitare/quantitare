require 'rails_helper'

RSpec.describe Scrobblers::WebhookScrobbler do
  let(:scrobble_params) { { category: 'log', data: { content: 'stuff' } }.to_json }
  let(:scrobbler) { build(:webhook_scrobbler, token: 'foobar', scrobble_params: scrobble_params) }
  let(:payload) { ActionController::Parameters.new(token: 'foobar') }
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

    it 'creates a scrobble' do
      expect { scrobbler.handle_webhook(request) }.to change(Scrobble, :count).by(1)
    end

    it 'creates a scrobble with the correct parameters' do
      scrobbler.handle_webhook(request)

      expect(Scrobble.last.data['content']).to eq('stuff')
    end

    context 'when the token does not match' do
      let(:payload) { ActionController::Parameters.new(token: 'nottherightone') }

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

    context 'with templated params' do
      let(:scrobble_params) { { category: 'log', data: { '{{ field_1 }}' => '{{ field_2 }}' } }.to_json }
      let(:payload) { ActionController::Parameters.new(token: 'foobar', field_1: 'content', field_2: 'hello') }

      it 'is valid' do
        expect(scrobbler).to be_valid
      end

      it 'returns 2xx' do
        expect(scrobbler.handle_webhook(request).status).to eq(200)
      end

      it 'sets the data properly' do
        scrobbler.handle_webhook(request)

        expect(Scrobble.last.data['content']).to eq('hello')
      end
    end

    context 'with more complicated templated params' do
      let(:scrobble_params) { <<~JSON }
        {
          "category": "data",
          "data": {{ custom_data | to_json }}
        }
      JSON

      let(:payload) do
        ActionController::Parameters.new({
          token: 'foobar', custom_data: { field_a: 'will', field_b: 'this', field_c: 'work' }
        })
      end

      it 'is valid' do
        expect(scrobbler).to be_valid
      end

      it 'returns 2xx' do
        expect(scrobbler.handle_webhook(request).status).to eq(200)
      end

      it 'sets the data properly' do
        scrobbler.handle_webhook(request)

        expect(Scrobble.last.data['field_b']).to eq('this')
      end
    end
  end
end

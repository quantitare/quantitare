# frozen_string_literal: true

module Scrobblers
  ##
  # = WebhookScrobbler
  #
  class WebhookScrobbler < Scrobbler
    include Templatable
    include LiquidDroppable

    configure_options(:options) do
      attribute :token, String, default: 'supersecretstring'
      attribute :verbs, String, default: 'post'

      attribute :response_code, Integer, default: '200'
      attribute :response_body, String, default: 'scrobble created'

      attribute :scrobble_params, String,
        default: { category: 'log', data: { content: 'scrobble' } }.to_json,
        display: { field: :json }

      validate do |options|
        JSON.parse(options.scrobble_params)
      rescue JSON::ParserError
        errors[:scrobble_params] << 'must be valid JSON'
      end
    end

    # @param request [ActionDispatch::Request] the inbound webhook request object
    def handle_webhook(request)
      params, token, verb = prepare_webhook(request)

      return WebResponse.new(content: 'not authorized', status: 401) unless valid_token?(token)
      return WebResponse.new(content: 'please use a valid HTTP verb', status: 401) unless valid_verb?(verb)

      create_scrobble(parsed_scrobble_params(params))

      WebResponse.new(content: options.response_body, status: options.response_code)
    end

    def parsed_scrobble_params(params)
      template_with(params.permit!.to_h) do
        JSON.parse(templated['scrobble_params']).with_indifferent_access.reverse_merge(timestamp: Time.current)
      end
    end

    def accepted_verbs
      options.verbs.split(/,/).map(&:strip).map(&:downcase).select(&:present?)
    end

    def valid_verb?(verb)
      verb.in?(accepted_verbs)
    end

    def valid_token?(token)
      options.token == token
    end

    private

    def prepare_webhook(request)
      params = request.params.except(:action, :controller, :user_id, :scrobbler_id, :format)
      verb = request.method_symbol.to_s.downcase
      token = params.delete(:token)

      [params, token, verb]
    end
  end
end

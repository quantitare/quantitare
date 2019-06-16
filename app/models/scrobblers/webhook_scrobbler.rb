# frozen_string_literal: true

module Scrobblers
  ##
  # = WebhookScrobbler
  #
  class WebhookScrobbler < Scrobbler
    configure_options(:options) do
      attribute :token, String, default: 'supersecretstring'
      attribute :verbs, String, default: 'post'
      attribute :response_code, Integer, default: '200'
      attribute :response_body, String, default: 'scrobble created'
    end

    def handle_webhook(request)
      _params, token, verb = prepare_webhook(request)

      return WebResponse.new(content: 'not authorized', status: 401) unless valid_token?(token)
      return WebResponse.new(content: 'please use a valid HTTP verb', status: 401) unless valid_verb?(verb)

      WebResponse.new(content: options.response_body, status: options.response_code)
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

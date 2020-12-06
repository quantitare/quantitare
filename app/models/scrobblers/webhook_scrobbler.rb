# frozen_string_literal: true

module Scrobblers
  ##
  # = WebhookScrobbler
  #
  class WebhookScrobbler < Scrobbler
    include Templatable
    include LiquidDroppable

    VERBS = %w[GET POST PUT PATCH DELETE].freeze

    attr_json :token, :string, default: 'supersecretstring', display: { help: 'A secret, URL safe token' }
    attr_json :verbs, :string,
      array: true, default: ['POST'], display: { help: 'A list of acceptable HTTP verbs', selection: VERBS }

    attr_json :response_code, :integer,
      default: 200, display: { help: 'The HTTP status code for a successful response' }
    attr_json :response_body, :string, default: 'scrobble created', display: { field: :textarea }

    attr_json :scrobble_params, :string,
      default: { category: 'log', data: { content: 'scrobble' } }.to_json,
      display: { field: :code, languages: [:json] }

    validates :verbs, length: { minimum: 1, too_short: 'at least one verb required' }

    not_schedulable!

    # @param request [ActionDispatch::Request] the inbound webhook request object
    def handle_webhook(request)
      params, token, verb = prepare_webhook(request)

      return WebResponse.new(content: 'not authorized', status: 401) unless valid_token?(token)
      return WebResponse.new(content: 'please use a valid HTTP verb', status: 401) unless valid_verb?(verb)

      create_scrobble(parsed_scrobble_params(params))

      WebResponse.new(content: response_body, status: response_code)
    end

    def parsed_scrobble_params(params)
      template_with(params) do
        JSON.parse(templated['scrobble_params']).with_indifferent_access.reverse_merge(timestamp: Time.current)
      end
    end

    def accepted_verbs
      verbs.map(&:strip).map(&:downcase).select(&:present?)
    end

    def valid_verb?(verb)
      verb.in?(accepted_verbs)
    end

    def valid_token?(token)
      self.token == token
    end

    private

    def prepare_webhook(request)
      params = request.params.to_unsafe_h.except(:action, :controller, :user_id, :scrobbler_id, :format)
      verb = request.method_symbol.to_s.downcase
      token = params.delete(:token)

      [params, token, verb]
    end
  end
end

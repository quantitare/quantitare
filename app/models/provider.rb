# frozen_string_literal: true

##
# A registry for OmniAuth providers. Provides a unified interface for registering omniauth providers and checking for
# valid credentials.
#
# rubocop:disable Metrics/ClassLength
class Provider
  @registry = {}.with_indifferent_access

  class << self
    attr_reader :registry

    delegate :[], to: :registry

    def register(provider_name, *args)
      instance = new(provider_name, *args)
      registry[provider_name] = instance
      instance.process!
    end

    def register_non_oauth(provider_name, *args, **kwargs)
      instance = TokenProvider.new(provider_name, *args, **kwargs)
      registry[provider_name] = instance
    end

    def oauth_providers
      registry.values.select(&:oauth?)
    end

    def non_oauth_providers
      registry.values.reject(&:oauth?)
    end

    def non_oauth_provider_names
      registry.keys.reject { |key| self[key].oauth? }
    end
  end

  attr_reader :name, :key, :secret, :oauth_opts

  def initialize(name, key_env_var, secret_env_var, opts = {})
    @name = name
    @key = ENV[key_env_var]
    @secret = ENV[secret_env_var]

    @oauth_opts = opts
  end

  alias provider_options oauth_opts
  alias options oauth_opts

  def oauth?
    true
  end

  def valid?
    name.present? && key.present? && secret.present?
  end

  def process!
    return false unless valid?

    Devise.setup { |config| config.omniauth(name, key, secret, oauth_opts) }
  end

  def icon_css_class
    oauth_opts[:icon_css_class]
  end

  def icon_text_color
    oauth_opts[:icon_text_color]
  end

  def icon_bg_color
    oauth_opts[:icon_bg_color]
  end

  Provider.register(
    :flickr, 'FLICKR_OAUTH_KEY', 'FLICKR_OAUTH_SECRET',
    strategy_class: OmniAuth::Strategies::Flickr,
    scope: 'read',

    icon_css_class: 'fab fa-flickr',
    icon_text_color: '#fff',
    icon_bg_color: '#ff0084'
  )

  Provider.register(
    :foursquare, 'FOURSQUARE_OAUTH_KEY', 'FOURSQUARE_OAUTH_SECRET',
    strategy_class: OmniAuth::Strategies::Foursquare,

    icon_css_class: 'fab fa-foursquare',
    icon_text_color: '#fff',
    icon_bg_color: '#2d5be3'
  )

  Provider.register(
    :lastfm, 'LASTFM_OAUTH_KEY', 'LASTFM_OAUTH_SECRET',
    strategy_class: OmniAuth::Strategies::Lastfm,

    icon_css_class: 'fab fa-lastfm',
    icon_text_color: '#fff',
    icon_bg_color: '#b90000'
  )

  Provider.register(
    :trakt, 'TRAKT_OAUTH_KEY', 'TRAKT_OAUTH_SECRET',
    strategy_class: OmniAuth::Strategies::Trakt,

    icon_css_class: 'fas fa-film',
    icon_text_color: '#fff',
    icon_bg_color: '#ed1a25'
  )

  Provider.register(
    :twitter, 'TWITTER_OAUTH_KEY', 'TWITTER_OAUTH_SECRET',
    strategy_class: OmniAuth::Strategies::Twitter,

    icon_css_class: 'fab fa-twitter',
    icon_text_color: '#fff',
    icon_bg_color: '#55acee'
  )

  Provider.register(
    :withings2, 'WITHINGS_OAUTH_KEY', 'WITHINGS_OAUTH_SECRET',
    strategy_class: OmniAuth::Strategies::Withings2,

    client_id: ENV['WITHINGS_OAUTH_KEY'],

    scope: 'user.activity,user.metrics,user.info',
    redirect_uri: ENV['WITHINGS_REDIRECT_URI'], # TODO: remove this for production purposes

    icon_css_class: 'fas fa-heartbeat',
    icon_text_color: '#fff',
    icon_bg_color: '#22ea9d'
  )

  Provider.register_non_oauth(
    :rescuetime,
    fields: { token: { as: :api_key } },

    icon_css_class: 'far fa-clock',
    icon_text_color: '#fff',
    icon_bg_color: '#667b8b'
  )

  Provider.register_non_oauth(
    :todoist,
    fields: { token: { as: :api_token } },

    icon_css_class: 'fas fa-check-double',
    icon_text_color: '#fff',
    icon_bg_color: '#e44232'
  )
end
# rubocop:enable Metrics/ClassLength

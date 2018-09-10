# frozen_string_literal: true

##
# A registry for Omniauth providers. Provides a unified interface for registering omniauth providers and checking for
# valid credentials.
#
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
  end

  attr_reader :name, :key, :secret, :oauth_opts

  def initialize(name, key_env_var, secret_env_var, opts = {})
    @name = name
    @key = ENV[key_env_var]
    @secret = ENV[secret_env_var]

    @oauth_opts = opts
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

  register(
    :foursquare, 'FOURSQUARE_OAUTH_KEY', 'FOURSQUARE_OAUTH_SECRET',
    strategy_class: OmniAuth::Strategies::Foursquare,

    icon_css_class: 'fab fa-foursquare',
    icon_text_color: '#fff',
    icon_bg_color: '#2d5be3'
  )

  register(
    :lastfm, 'LASTFM_OAUTH_KEY', 'LASTFM_OAUTH_SECRET',
    strategy_class: OmniAuth::Strategies::Lastfm,

    icon_css_class: 'fab fa-lastfm',
    icon_text_color: '#fff',
    icon_bg_color: '#b90000'
  )
end
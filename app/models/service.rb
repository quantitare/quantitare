# frozen_string_literal: true

##
# Stores credentials for an external service used to retrieve data from.
#
class Service < ApplicationRecord
  ISSUE_NATURES = [
    IN_REFRESH_TOKEN = 'refresh_token',
    IN_USER_TOKEN = 'user_token',
    IN_PROVIDER_CREDENTIALS = 'provider_credentials',
    IN_REQUEST_FORMAT = 'request_format',
    IN_GENERAL = 'general'
  ].freeze

  belongs_to :user, inverse_of: :services
  has_many :scrobblers, inverse_of: :service, dependent: :destroy

  validates :user_id, presence: true
  validates :provider, presence: true
  validates :name, presence: true
  validates :token, presence: true

  scope :available_to_user, ->(user) { where(user_id: user.id) }
  scope :for_place_metadata, -> { where(provider: 'foursquare', global: true) }

  @available_providers = {}.with_indifferent_access

  class << self
    attr_reader :available_providers

    def register_provider(provider_name, &blk)
      available_providers[provider_name] = blk
    end

    def lookup_provider(omniauth)
      available_providers.fetch(omniauth[:provider], available_providers[:default]).(omniauth)
    end

    def find_or_initialize_via_omniauth(omniauth)
      options = get_options(omniauth)

      find_or_initialize_by(provider: omniauth[:provider], uid: omniauth[:uid].to_s).tap do |service|
        service.assign_attributes(
          token: omniauth[:credentials][:token],
          secret: omniauth[:credentials][:secret],
          name: options[:name],
          refresh_token: omniauth[:credentials][:refresh_token],
          expires_at: omniauth[:credentials][:expires_at] && Time.zone.at(omniauth[:credentials][:expires_at]),
          options: options
        )
      end
    end

    def get_options(omniauth)
      available_providers.fetch(omniauth['provider'].to_sym, available_providers[:default]).(omniauth)
    end
  end

  def expired?
    Time.current > expires_at
  rescue ArgumentError
    false
  end

  def issues?
    issues.present?
  end

  def report_issue!(nature, message)
    issues << new_issue(nature, message)
    save!
  end

  def clear_issues!
    issues.clear
    save!
  end

  def new_issue(nature, message)
    { nature: nature, message: message }
  end

  def provider_data
    Provider[provider]
  end

  def provider_key
    provider_data.key
  end

  def provider_secret
    provider_data.secret
  end

  register_provider(:default) do |omniauth|
    { name: omniauth[:info][:nickname] || omniauth[:info][:name] }
  end

  register_provider(:foursquare) do |omniauth|
    { name: omniauth[:info][:email] }
  end

  register_provider(:withings2) do |_omniauth|
    { name: 'Withings' }
  end
end

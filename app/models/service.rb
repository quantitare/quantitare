# frozen_string_literal: true

##
# Stores credentials for an external service used to retrieve data from.
#
class Service < ApplicationRecord
  belongs_to :user, inverse_of: :services
  has_many :scrobblers, inverse_of: :service

  validates :user_id, presence: true
  validates :provider, presence: true
  validates :name, presence: true
  validates :token, presence: true

  scope :available_to_user, ->(user) { where(user_id: user.id) }

  @available_providers = {}.with_indifferent_access

  class << self
    attr_reader :available_providers

    def register_provider(provider_name, &blk)
      available_providers[provider_name] = blk
    end

    def lookup_provider(omniauth)
      available_providers.fetch(omniauth['provider'], available_providers['default']).call(omniauth)
    end
  end

  register_provider(:default) do |omniauth|
    { name: omniauth['info']['nickname'] || omniauth['info']['name'] }
  end
end

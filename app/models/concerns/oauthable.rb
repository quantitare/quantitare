# frozen_string_literal: true

##
# A mixin that provides functionality to connect
#
module Oauthable
  extend ActiveSupport::Concern

  included do
    @valid_oauth_providers = :all
    validates :service_id, presence: true
  end

  class_methods do
    def valid_oauth_providers(*providers)
      return @valid_oauth_providers if providers.empty?
      @valid_oauth_providers = providers
    end

    alias_method :valid_oauth_provider, :valid_oauth_providers
  end

  def oauthable?
    true
  end

  def valid_services_for(user)
    if valid_oauth_providers == :all
      user.available_services
    else
      user.available_services.where(provider: valid_oauth_providers)
    end
  end

  def valid_oauth_providers
    self.class.valid_oauth_providers
  end
end

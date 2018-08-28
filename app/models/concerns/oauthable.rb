# frozen_string_literal: true

##
# A mixin that provides functionality to connect
#
module Oauthable
  extend ActiveSupport::Concern

  class_methods do
    attr_reader :required_provider

    def requires_provider?
      required_provider.present?
    end

    def requires_provider(provider_name)
      instance_variable_set('@required_provider', provider_name)

      validates :service_id, presence: true

      validates_each :service do |record, attr, value|
        record.errors.add(attr, "must be a service for #{provider_name}") if value.try(:provider) != provider_name
      end
    end
  end

  def requires_provider?
    self.class.requires_provider?
  end

  def required_provider
    self.class.required_provider
  end

  def valid_services_for(user)
    user.available_services.where(provider: required_provider)
  end
end

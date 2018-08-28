# frozen_string_literal: true

##
# Presentation logic for {Service}s
#
class ServiceDecorator < ApplicationDecorator
  delegate_all

  def label_text
    "#{h.omniauth_provider_name(provider)} - #{name}"
  end
end

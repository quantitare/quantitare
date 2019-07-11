# frozen_string_literal: true

##
# Presentation logic for {Service}s
#
class ServiceDecorator < ApplicationDecorator
  delegate_all

  def display_name
    h.omniauth_provider_name(provider)
  end

  def label_text
    "#{display_name} - #{name}"
  end
end

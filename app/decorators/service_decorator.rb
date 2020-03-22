# frozen_string_literal: true

##
# Presentation logic for {Service}s
#
class ServiceDecorator < ApplicationDecorator
  include Rails.application.routes.url_helpers

  delegate_all

  def display_name
    h.omniauth_provider_name(provider)
  end

  def label_text
    "#{display_name} - #{name}"
  end

  def callback_url
    h.public_send("user_#{provider}_omniauth_callback_url")
  end
end

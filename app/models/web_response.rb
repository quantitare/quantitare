# frozen_string_literal: true

##
# An object that contains the basic information to format an outbound HTTP response. Designed to be simple and
# frictionless, and thus not meant as a robust solution for formatting responses.
#
class WebResponse
  include Virtus.model

  attribute :content
  attribute :status, Integer, default: 200
  attribute :content_type, String, default: 'text/plain'
  attribute :headers, Hash

  def redirect?
    status.in?([301, 302])
  end

  def text?
    content.is_a?(String)
  end

  def json?
    content.is_a?(Hash)
  end
end

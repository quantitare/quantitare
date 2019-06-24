# frozen_string_literal: true

##
# This controller is modeled after Huginn's +WebRequestsController+, and is designed to allow scrobblers to receive
# inbound HTTP requests and process scrobbles from them. The scrobbler must implement the method +#handle_webhook+,
# which takes an +ActionDispatch::Request+ object and should return a {WebResponse} object.
#
class WebhooksController < ApplicationController
  def handle
    return unless set_user && set_scrobbler

    scrobbler_response = scrobbler.handle_webhook(request)
    handle_web_response(scrobbler_response)
  end

  private

  def set_user
    @user = User.find_by(id: params[:user_id])

    if @user.present?
      @user
    else
      render plain: 'user not found', status: :not_found
      nil
    end
  end

  def set_scrobbler
    @scrobbler = @user.scrobblers.find_by(id: params[:scrobbler_id])

    if @scrobbler.present?
      @scrobbler
    else
      render plain: 'scrobbler not found', status: :not_found
      nil
    end
  end

  def handle_web_response(web_response)
    web_response.headers.each { |k, v| response.headers[k] = v } if web_response.headers.present?
    render_or_redirect_for_web_response(web_response)
  end

  def render_or_redirect_for_web_response(web_response)
    if web_response.redirect?
      handle_redirect(web_response)
    elsif web_response.text?
      handle_text(web_response)
    elsif web_response.json?
      handle_json(web_response)
    else
      head(web_response.status)
    end
  end

  def handle_redirect(web_response)
    redirect_to web_response.content, status: web_response.status
  end

  def handle_text(web_response)
    render plain: web_response.content, status: web_response.status, content_type: web_response.content_type
  end

  def handle_json(web_response)
    render json: web_response.content, status: web_response.status
  end
end

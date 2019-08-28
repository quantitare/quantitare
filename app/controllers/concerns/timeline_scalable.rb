# frozen_string_literal: true

##
# Shared logic for "timeline scale"-related functions, such as the scale and date requested, as well as the related
# categories
#
module TimelineScalable
  extend ActiveSupport::Concern

  DEFAULT_SCALE = 'day'

  included do
    rescue_from TimelineQuery::InvalidScaleError, with: :not_found!
    helper_method :scale, :date, :categories

    before_action :set_time_zone
  end

  private

  def scale
    params[:scale].presence || DEFAULT_SCALE
  end

  def date
    Date.parse(params[:date].presence || default_date)
  end

  def categories
    (params[:categories].presence || '').split(',').map(&:strip)
  end

  def default_date
    Date.current.to_s
  end

  private

  # TODO: Temporary
  def set_time_zone
    Time.zone = 'US/Pacific'
  end
end

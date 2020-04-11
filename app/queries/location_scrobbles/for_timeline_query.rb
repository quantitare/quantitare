# frozen_string_literal: true

module LocationScrobbles
  ##
  # Fetches location scrobbles based on a given scale and span of time
  #
  class ForTimelineQuery < TimelineQuery
    relation LocationScrobble
    params :scale, :date
  end
end

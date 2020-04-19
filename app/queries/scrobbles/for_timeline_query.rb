# frozen_string_literal: true

module Scrobbles
  ##
  # Fetches scrobbles based on a given scale and span of time
  #
  class ForTimelineQuery < TimelineQuery
    relation Scrobble
    params :scale, :date, categories: []

    def call
      @relation = super.where(category: categories)
    end
  end
end

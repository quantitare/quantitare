# frozen_string_literal: true

##
# Performs a check on a given scrobbler.
#
class ScrobblerCheckJob < ApplicationJob
  def perform(scrobbler, check)
    scrobbler.run_check(check)
  end
end

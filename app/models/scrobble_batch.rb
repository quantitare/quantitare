# frozen_string_literal: true

##
# A batch of scrobbles, with some metadata and failure information attached.
#
class ScrobbleBatch
  include Enumerable

  attr_reader :scrobbles, :source, :start_time, :end_time, :error

  def initialize(scrobbles = [], source:, start_time:, end_time:, error: nil)
    @scrobbles = scrobbles

    @source = source

    @start_time = start_time
    @end_time = end_time

    @error = error
  end

  def each
    return enum_for(:each) unless block_given?

    scrobbles.each { |scrobble| yield(scrobble) }
  end

  def success?
    error.blank?
  end

  def failure?
    !success?
  end
end

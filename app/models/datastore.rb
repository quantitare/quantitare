# frozen_string_literal: true

##
# A wrapper for an in-memory key-value datastore. Reduces direct dependencies on cache stores like Redis.
#
class Datastore
  delegate :[], :[]=, :del, :keys, to: :client

  def client
    @client ||= Redis.new
  end
end

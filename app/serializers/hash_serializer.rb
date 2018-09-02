# frozen_string_literal: true

##
# Serializes a JSON-compatible hash into one that has indifferent access, so JSON datatype columns can be traversed
# using symbols as well as strings.
#
class HashSerializer
  class << self
    def dump(hash)
      hash
    end

    def load(hash)
      (hash || {}).with_indifferent_access
    end
  end
end

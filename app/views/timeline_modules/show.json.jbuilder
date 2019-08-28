# frozen_string_literal: true

json.key_format! camelize: :lower

json.datasets do
  json.merge! @assimilator.datapoints
end

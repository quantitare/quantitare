# frozen_string_literal: true

json.key_format! camelize: :lower

json.chart_options do
  json.merge! @assimilator.chart_options(@name.to_sym)
end

json.summaries do
  json.merge! @assimilator.summaries(@name.to_sym)
end

# frozen_string_literal: true

json.key_format! camelize: :lower

json.array!(@places) { |place| json.partial! 'place', place: place }

# frozen_string_literal: true

class WithingsAdapter
  ##
  # @private
  #
  class WorkoutSample
    WORKOUT_TYPES = {
      1 => 'walk',
      2 => 'run',
      3 => 'hiking',
      4 => 'skating',
      5 => 'bmx',
      6 => 'bicycling',
      7 => 'swimming',
      8 => 'surfing',
      9 => 'kitesurfing',
      10 => 'windsurfing',
      11 => 'bodyboard',
      12 => 'tennis',
      13 => 'table_tennis',
      14 => 'squash',
      15 => 'badminton',
      16 => 'lift_weights',
      17 => 'calisthenics',
      18 => 'elliptical',
      19 => 'pilates',
      20 => 'basketball',
      21 => 'soccer',
      22 => 'football',
      23 => 'rugby',
      24 => 'volleyball',
      25 => 'waterpolo',
      26 => 'horse_riding',
      27 => 'golf',
      28 => 'yoga',
      29 => 'dancing',
      30 => 'boxing',
      31 => 'fencing',
      32 => 'wrestling',
      33 => 'martial_arts',
      34 => 'skiing',
      35 => 'snowboarding',
      36 => 'other',
      187 => 'rowing',
      188 => 'zumba',
      191 => 'baseball',
      192 => 'handball',
      193 => 'hockey',
      194 => 'ice_hockey',
      195 => 'climbing',
      196 => 'ice_skating',
      272 => 'multi_sport',
      307 => 'indoor_running'
    }.freeze

    attr_reader :category, :response_data

    def initialize(category, response_data, _config = {})
      @category = category
      @response_data = response_data
    end

    # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, Metrics/MethodLength
    def to_scrobble
      return [] unless response_data['category'].in?(WORKOUT_TYPES.keys)

      ::Scrobble.new(
        category: category,
        start_time: Time.zone.at(response_data['startdate'].to_i),
        end_time: Time.zone.at(response_data['enddate'].to_i),

        data: data
      )
    end

    def data
      { type: WORKOUT_TYPES[response_data['category']] }.tap do |h|
        h[:effective_duration] = detail_data['effduration'].to_f if detail_data['effduration']
        h[:calories] = detail_data['calories'].to_f if detail_data['categories']
        h[:distance] = detail_data['distance'].to_f if detail_data['distance']
        h[:steps] = detail_data['steps'] if detail_data['steps']
        h[:floors_climbed] = detail_data['elevation'].to_f if detail_data['elevation']

        h[:heart_rate_average] = detail_data['hr_average'].to_f if detail_data['hr_average']
        h[:heart_rate_min] = detail_data['hr_min'].to_f if detail_data['hr_min']
        h[:heart_rate_max] = detail_data['hr_max'].to_f if detail_data['hr_max']

        h[:analysis] = {
          intensity: detail_data['intensity'],

          hr_zone_0: detail_data['hr_zone_0'],
          hr_zone_1: detail_data['hr_zone_1'],
          hr_zone_2: detail_data['hr_zone_2'],
          hr_zone_3: detail_data['hr_zone_3']
        }

        h[:supplementary_statistics] = {}
        h[:supplementary_statistics][:strokes] = detail_data['strokes'] if detail_data['strokes']
        h[:supplementary_statistics][:pool_laps] = detail_data['pool_laps'] if detail_data['pool_laps']
        h[:supplementary_statistics][:pool_length] = detail_data['pool_length'] if detail_data['pool_length']
      end
    end
    # rubocop:enable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, Metrics/MethodLength

    private

    def detail_data
      response_data['data']
    end
  end
end

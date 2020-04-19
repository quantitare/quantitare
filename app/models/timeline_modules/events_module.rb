# frozen_string_literal: true

module TimelineModules
  ##
  # A module that displays the "events"
  #
  # rubocop:disable Metrics/ClassLength, Metrics/MethodLength
  class EventsModule < TimelineModule
    self.component_name = 'events'

    timeline_group :task_completions, categories: ['task_completion']
    timeline_group :code_commits, categories: ['code_commit']
    timeline_group :social_shares, categories: ['social_share']

    highchart(:task_completions, groups: [:task_completions]) do |scrobble_groups, date_scale|
      chart_options(task_completions_series(scrobble_groups[:task_completions], date_scale), date_scale)
    end

    highchart(:code_commits, groups: [:code_commits]) do |scrobble_groups, date_scale|
      chart_options(code_commits_series(scrobble_groups[:code_commits], date_scale), date_scale)
    end

    highchart(:social_shares, groups: [:social_shares]) do |scrobble_groups, date_scale|
      chart_options(social_shares_series(scrobble_groups[:social_shares], date_scale), date_scale)
    end

    class << self
      def chart_options(series, date_scale)
        {
          series: series,

          chart: {
            height: 30,
            backgroundColor: 'rgba(255, 255, 255, 0)'
          },

          plotOptions: {
            timeline: {
              dataLabels: { enabled: false },
              lineWidth: 0,

              tooltip: {
                pointFormat: '<span class="timeline-tooltip-body">{point.description}</span>'
              }
            }
          },

          title: { text: nil },
          legend: { enabled: false },
          time: { useUTC: false },

          xAxis: {
            type: 'datetime',
            min: time_to_js(date_scale.beginning_of_scale),
            max: time_to_js(date_scale.end_of_scale),
            visible: false
          },

          yAxis: [
            {
              labels: { enabled: false },
              title: { text: nil },
              visible: false
            }
          ]
        }
      end

      def task_completions_series(scrobbles, _date_scale)
        [{
          name: 'Task completions',
          color: '#E08479',

          type: 'timeline',
          data: compiled_task_completion_scrobbles(scrobbles)
        }]
      end

      def compiled_task_completion_scrobbles(scrobbles)
        pairs_for_task_completion_scrobbles(scrobbles).sort_by { |pair| pair[:x] }
      end

      def pairs_for_task_completion_scrobbles(scrobbles)
        scrobbles.map do |scrobble|
          {
            x: time_to_js(scrobble.timestamp),

            name: 'Task completion',
            description: scrobble.data['name'],

            color: '#E08479'
          }
        end
      end

      def code_commits_series(scrobbles, _date_scale)
        [{
          name: 'Code commits',
          color: '#74E377',

          type: 'timeline',
          data: compiled_code_commit_scrobbles(scrobbles)
        }]
      end

      def compiled_code_commit_scrobbles(scrobbles)
        pairs_for_code_commit_scrobbles(scrobbles).sort_by { |pair| pair[:x] }
      end

      def pairs_for_code_commit_scrobbles(scrobbles)
        scrobbles.map do |scrobble|
          {
            x: time_to_js(scrobble.timestamp),

            name: 'Code commit',
            description: scrobble.data['message'],

            color: '#74E377'
          }
        end
      end

      def social_shares_series(scrobbles, _date_scale)
        [{
          name: 'Social shares',
          color: '#7EC7FA',

          type: 'timeline',
          data: compiled_social_share_scrobbles(scrobbles)
        }]
      end

      def compiled_social_share_scrobbles(scrobbles)
        pairs_for_social_share_scrobbles(scrobbles).sort_by { |pair| pair[:x] }
      end

      def pairs_for_social_share_scrobbles(scrobbles)
        scrobbles.map do |scrobble|
          {
            x: time_to_js(scrobble.timestamp),

            name: "#{scrobble.data['service'].titleize} share",
            description: scrobble.data['content'],

            color: '#7EC7FA'
          }
        end
      end
    end
  end
  # rubocop:enable Metrics/ClassLength, Metrics/MethodLength
end

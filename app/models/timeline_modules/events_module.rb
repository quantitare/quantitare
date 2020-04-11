# frozen_string_literal: true

module TimelineModules
  ##
  # A module that displays the "events"
  #
  class EventsModule < TimelineModule
    self.component_name = 'events'

    timeline_group(:task_completions, categories: ['task_completion']) do |scrobbles|
      [{
        name: 'Task completions',
        color: '#E08479',

        type: 'timeline',
        data: compiled_task_completion_scrobbles(scrobbles)
      }]
    end

    timeline_group(:code_commits, categories: ['code_commit']) do |scrobbles|
      [{
        name: 'Code commits',
        color: '#74E377',

        type: 'timeline',
        data: compiled_code_commit_scrobbles(scrobbles)
      }]
    end

    timeline_group(:social_shares, categories: ['social_share']) do |scrobbles|
      [{
        name: 'Social shares',
        color: '#7EC7FA',

        type: 'timeline',
        data: compiled_social_share_scrobbles(scrobbles)
      }]
    end

    class << self
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
end

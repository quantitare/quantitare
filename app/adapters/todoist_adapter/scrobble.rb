# frozen_string_literal: true

class TodoistAdapter
  ##
  # @private
  #
  class Scrobble
    class << self
      def completion_from_api(task, completion, metadata_adapter)
        new(task, completion, metadata_adapter).to_scrobble
      end
    end

    attr_reader :task, :completion, :metadata_adapter

    def initialize(task, completion, metadata_adapter)
      @task = task
      @completion = completion
      @metadata_adapter = metadata_adapter
    end

    def to_scrobble
      ::Scrobble.new(
        category: 'task_completion',
        timestamp: Time.zone.parse(completion.completed_date),

        data: data
      )
    end

    private

    def data
      { name: completion.content }.merge(optional_data)
    end

    def optional_data
      result = {}

      result[:priority] = priority if priority
      result[:list] = list if list
      result[:tags] = tags if tags

      result
    end

    def priority
      base = task.try(:[], 'item')&.priority

      base.present? ? base * 25 : nil
    end

    def list
      task.try(:[], 'project')&.name
    end

    def tags
      return nil unless task

      task['item'].labels.map { |label_id| Aux::Todoist::Label.fetch(id: label_id, adapter: metadata_adapter).name }
    end
  end
end

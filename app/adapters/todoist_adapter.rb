# frozen_string_literal: true

require 'todoist'

##
# API wrapper for the Todoist API
#
class TodoistAdapter
  BATCH_LIMIT = 50

  TempItem = Struct.new(:id)

  attr_reader :service

  def initialize(service)
    @service = service
  end

  def client
    @client ||= Todoist::Client.create_client_by_token(service.token)
  end

  def fetch_scrobbles(start_time, end_time, cadence: 0.seconds)
    fetch_raw_task_completions(start_time, end_time, cadence: cadence)
      .map { |completion| scrobble_for_completion(completion, cadence: cadence) }
  end

  def fetch_label(opts = {})
    opts = opts.symbolize_keys

    TodoistAdapter::Label.new(fetch_raw_label(opts[:id].to_i), service).to_aux
  end

  private

  def fetch_raw_task_completions(start_time, end_time, cadence: 0.seconds, offset: 0, list: [])
    new_items = wrap_api_call(cadence) do
      client.misc_completed.get_all_completed_items(
        'since' => start_time, 'until' => end_time,
        'limit' => BATCH_LIMIT, 'offset' => offset
      )['items']
    end

    return list if new_items.blank?

    fetch_raw_task_completions(
      start_time, end_time,
      cadence: cadence, offset: offset + BATCH_LIMIT, list: list + new_items
    )
  end

  def fetch_raw_task(task_id, cadence: 0.seconds)
    temp_item = TempItem.new(task_id)

    wrap_api_call(cadence, raise_error: false) { client.misc_items.get_item(temp_item) }
  end

  def fetch_raw_label(label_id)
    all_raw_labels[label_id]
  end

  def all_raw_labels
    @all_raw_labels ||= wrap_api_call { client.sync_labels.collection }
  end

  def wrap_api_call(cadence = 0.seconds, raise_error: true)
    result = yield

    sleep cadence

    result
  rescue Net::OpenTimeout
    raise Errors::ServiceAPIError, "A request to todoist service #{service.name} timed out"
  rescue StandardError => e
    handle_standard_error(e, raise_error)
  end

  def scrobble_for_completion(completion, cadence: 0.seconds)
    task = fetch_raw_task(completion.task_id, cadence: cadence)

    TodoistAdapter::Scrobble.completion_from_api(task, completion, self)
  end

  def handle_standard_error(error, raise_error = true)
    parsed_error =
      case error.message.match(/\AHTTP (\d+) Error/)&.[](1)
      when '400'..'499'
        Errors::ServiceConfigError
      when '500'..'599'
        Errors::ServiceAPIError
      else
        error
      end

    raise_error ? raise(parsed_error) : nil
  end
end

require_dependency 'todoist_adapter/scrobble'
require_dependency 'todoist_adapter/label'

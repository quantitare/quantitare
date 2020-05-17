# frozen_string_literal: true

class TodoistAdapter
  ##
  # @private
  #
  class Label
    attr_reader :raw_label, :service

    def initialize(raw_label, service)
      @raw_label = raw_label
      @service = service
    end

    def to_aux
      Aux::Todoist::Label.new(
        service: service,
        service_identifier: raw_label.id,

        data: data,

        expires_at: 1.month.from_now
      )
    end

    def data
      {
        identifier: raw_label.id,
        name: raw_label.name,
        color: raw_label.color
      }
    end
  end
end

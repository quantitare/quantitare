# frozen_string_literal: true

##
# Extensions to the default FormBuilder class
#
# rubocop:disable Metrics/BlockLength
module FormHelper
  ::ActionView::Helpers::FormBuilder.class_eval do
    # rubocop:disable Rails/HelperInstanceVariable
    def choices(attribute, select_options, **options)
      @template.content_tag(:div,
        data: {
          controller: 'choices',
          'choices-inner-class': options[:class],
          'choices-search-path': options[:search_path]
        }) do
        select(
          attribute, select_options, {},
          data: (options[:data] || {}).merge({
            target: @template.add_dom_classes('choices.select', options.dig(:data, :target))
          })
        )
      end
    end

    def optionable_field(config, **opts)
      public_send(*optionable_field_type_args(config, **opts), **opts)
    end

    def errors(attribute)
      return if object.errors[attribute].blank?

      @template.content_tag(:div, class: 'invalid-feedback') do
        object.errors[attribute].join(', ')
      end
    end
    # rubocop:enable Rails/HelperInstanceVariable

    private

    def optionable_field_type_args(config)
      if optionable_single_select?(config)
        ['select', optionable_selection_options(config), { include_blank: true }]
      elsif optionable_text_field?(config)
        ['text_field']
      end
    end

    def optionable_single_select?(config)
      config[:type] != 'array' && config[:display].key?(:selection)
    end

    def optionable_text_field?(config)
      config[:type] == 'string'
    end

    def optionable_selection_options(config)
      config[:display][:selection].map { |item| [item, item] }
    end
  end
end
# rubocop:enable Metrics/BlockLength

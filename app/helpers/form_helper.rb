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
        data: (options[:data] || {}).merge({
          controller: 'choices',
          'choices-inner-class': options[:class],
          'choices-search-path': options[:search_path],
          'choices-value': object.public_send(attribute)
        })) do
        select(
          attribute, select_options, { include_blank: true, include_hidden: false },
          data: (options[:select_data] || {}).merge({
            target: @template.add_dom_classes('choices.select', options.dig(:data, :target))
          }),
          **options
        )
      end
    end

    def code_field(attribute, **opts)
      text_area attribute, **opts.deep_merge({ data: { controller: 'code-field' } })
    end

    def optionable_field(config, **opts)
      public_send(*optionable_field_type_args(config), **optionable_field_type_opts(config, **opts))
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
      if optionable_single_select?(config) || optionable_multi_select?(config)
        ['choices', config[:name], optionable_selection_options(config)]
      elsif optionable_textarea_field?(config)
        ['text_area', config[:name]]
      elsif optionable_code_field?(config)
        ['code_field', config[:name]]
      else
        ['text_field', config[:name]]
      end
    end

    def optionable_field_type_opts(config, **opts)
      if optionable_multi_select?(config)
        opts.merge({ multiple: true })
      elsif optionable_code_field?(config)
        opts.deep_merge({
          data: { 'code-field-languages': (config.dig(:display, :languages) || ['json']).to_json }
        })
      else
        opts
      end
    end

    def optionable_single_select?(config)
      config[:type] != :array && optionable_has_selection?(config)
    end

    def optionable_multi_select?(config)
      config[:type] == :array && optionable_has_selection?(config)
    end

    def optionable_textarea_field?(config)
      config.dig(:display, :field) == :textarea
    end

    def optionable_code_field?(config)
      config.dig(:display, :field) == :code
    end

    def optionable_has_selection?(config)
      config[:display]&.key?(:selection)
    end

    def optionable_selection_options(config)
      config[:display][:selection].map { |item| [item, item] }
    end
  end
end
# rubocop:enable Metrics/BlockLength

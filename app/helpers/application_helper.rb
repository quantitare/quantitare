# frozen_string_literal: true

##
# Helper methods for controllers & views.
#
module ApplicationHelper
  def available_alerts
    flash.map do |level, content|
      level = level == 'notice' ? 'primary' : level

      {
        id: SecureRandom.hex,
        level: level,
        content: content.capitalize
      }
    end
  end

  def json_partial(partial_name, opts = {})
    opts = { partial: partial_name, formats: [:json] }.merge(opts)
    render opts
  end

  def j_json_partial(*args)
    j raw json_partial(*args)
  end

  def model_url_for(model, *args)
    model =
      if model.class.superclass == ApplicationRecord || model.class.superclass == ApplicationDecorator
        model
      else
        model.becomes(model.class.superclass)
      end

    url_for(model, *args)
  end

  def friendly_format_time(time)
    time.strftime('%-d %b %Y %l:%M:%S%P')
  end

  def badge_tag(content = '', type: 'secondary')
    content_tag :span, content, class: "badge badge-#{type}"
  end

  def errors_for(object)
    return unless object.errors.any?

    content_tag(:div, class: 'card border-danger mb-4') do
      concat error_header_for_object(object)
      concat error_list_for_object(object)
    end
  end

  def nav_link(name, path, options = {})
    options = options.deep_dup
    options[:class] = add_dom_classes(options[:class], 'nav-link nav-item')

    active = current_page?(path)

    options[:class] = add_dom_classes(options[:class], 'active') if active

    link_to name, path, options
  end

  def omniauth_provider_icon_tag(provider_name)
    icon_tag Provider[provider_name].icon
  end

  def omniauth_button(provider)
    link_to(
      omniauth_button_text(provider), user_omniauth_authorize_path(provider),
      class: "btn btn-secondary btn-service btn-service-#{provider}"
    )
  end

  def non_omniauth_provider_button(provider, **link_options)
    link_to(
      omniauth_button_text(provider), new_service_path(service: { provider: provider }),
      class: "btn btn-secondary btn-service btn-service-#{provider}", **link_options
    )
  end

  def omniauth_button_text(provider)
    [
      omniauth_provider_icon_tag(provider),
      content_tag(:span, "Authenticate with #{omniauth_provider_name(provider)}")
    ].join(' ').html_safe
  end

  def add_dom_classes(original_dom_class, *additional_classes)
    all_classes = (original_dom_class || '').split(' ')
    all_classes += additional_classes.compact.flat_map { |additional_class| additional_class.split(' ') }

    all_classes.uniq.join(' ').squish.strip
  end

  private

  def error_header_for_object(object)
    error_plural = pluralize(object.errors.count, 'error')

    content_tag(:div, class: 'card-header bg-danger text-white') do
      concat "#{error_plural} prohibited this #{object.class.name.underscore.humanize.downcase} from being saved:"
    end
  end

  def error_list_for_object(object)
    content_tag(:div, class: 'card-body') do
      concat(content_tag(:ul, class: 'mb-0') do
        object.errors.full_messages.each do |msg|
          concat content_tag(:li, msg)
        end
      end)
    end
  end

  def humanize_type(type)
    type.gsub(/\A.*::/, '').titleize
  end
end

# frozen_string_literal: true

##
# Helper methods for controllers & views.
#
module ApplicationHelper
  def icon_tag(icon_class, options = {})
    icon_class ||= 'fa fa-lock'
    dom_class = add_dom_classes(options[:class], icon_class)

    content_tag :i, nil, class: dom_class
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

  def omniauth_provider_icon_tag(provider)
    icon_class = Devise.omniauth_configs[provider.to_sym].options[:icon_class]
    icon_tag(icon_class)
  end

  def omniauth_button(provider)
    link_to(
      omniauth_button_text(provider), user_omniauth_authorize_path(provider),
      class: "btn btn-secondary btn-service btn-service-#{provider}"
    )
  end

  def omniauth_provider_name(provider)
    t("devise.omniauth_providers.#{provider}")
  end

  def omniauth_button_text(provider)
    [
      omniauth_provider_icon_tag(provider),
      content_tag(:span, "Authenticate with #{omniauth_provider_name(provider)}")
    ].join(' ').html_safe
  end

  def add_dom_classes(original_dom_class, *additional_classes)
    output = (original_dom_class || '')
    new_classes = additional_classes.join(' ')
    output += ' ' + new_classes

    output.squish
  end

  def user_omniauth_authorize_path(provider)
    send "user_#{provider}_omniauth_authorize_path"
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
end

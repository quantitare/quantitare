# frozen_string_literal: true

##
# Helper methods for controllers & views.
#
module ApplicationHelper
  def nav_link(name, path, options = {})
    options[:class] ||= ''
    options[:class] += ' nav-link nav-item'

    active = current_page?(path)

    options[:class] += ' active' if active
    options[:class] = options[:class].strip

    link_to(name, path, options)
  end
end

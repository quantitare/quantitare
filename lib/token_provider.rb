# frozen_string_literal: true

##
# A registry for non-OAuth providers. Provides a way of accepting credentials for services that don't require OAuth.
#
class TokenProvider
  attr_reader :name, :options

  def initialize(name, **options)
    @name = name
    @options = options
  end

  def oauth?
    false
  end

  def fields
    options[:fields]
  end

  def icon
    Icon.for(:fa, name: icon_css_class)
  end

  def icon_css_class
    options[:icon_css_class]
  end

  def icon_text_color
    options[:icon_text_color]
  end

  def icon_bg_color
    options[:icon_bg_color]
  end
end

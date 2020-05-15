# frozen_string_literal: true

##
# Represents a provider that does not link out to an external service. {Service} records aren't created from scrobblers
# that hook up to these. Instead, they become {Scrobbler}s in themselves, where +service+ is +nil+.
#
class InternalProvider
  attr_reader :name, :options

  def initialize(name, **options)
    @name = name
    @options = options
  end

  def oauth?
    false
  end

  def internal?
    true
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

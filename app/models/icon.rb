# frozen_string_literal: true

##
# Abstract superclass for icons of different types (FontAwesome, images, etc.)
#
class Icon
  class InvalidTypeError < StandardError; end

  TYPES = {
    fa: FontAwesomeIcon,
    img: ImageIcon
  }.freeze

  class << self
    def for(type, **options)
      TYPES[type.to_sym].new(**options)
    rescue NoMethodError
      raise InvalidTypeError, "could not find a valid icon class for type :#{type}"
    end
  end

  attr_reader :options

  def initialize(**options)
    @options = options.symbolize_keys
  end

  # Add a specially-formatted tag to the helper's template buffer to display an icon.
  def tag(_helper, **_props)
    raise NotImplementedError
  end

  def to_h
    raise NotImplementedError
  end
end

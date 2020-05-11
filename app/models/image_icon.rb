# frozen_string_literal: true

##
# Generates HTML tags, etc. for displaying image-based icons.
#
class ImageIcon < Icon
  def tag(helper, **props)
    helper.image_tag src(props[:size] || :xl), **props
  end

  def to_h
    options.merge({ type: 'img' })
  end

  private

  def src(size)
    options[size.to_sym]
  end
end

# frozen_string_literal: true

##
# Generates HTML tags, etc. for displaying FontAwesome-based icons.
#
class FontAwesomeIcon < Icon
  # @see Icon#tag
  def tag(helper, **props)
    final_dom_class = helper.add_dom_classes(props.delete(:class), icon_class)

    helper.content_tag :i, nil, props.merge(class: final_dom_class)
  end

  def to_h
    {
      type: :fa,
      name: options[:name]
    }
  end

  private

  def icon_class
    options[:name] || 'fas fa-question-circle'
  end
end

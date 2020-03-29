# frozen_string_literal: true

# Random tag wrappers go here
module TagHelper
  def page_header_tag(text)
    content_tag(:div, class: 'row border-bottom pb-2 mb-3') do
      content_tag(:h2) { text }
    end
  end
end

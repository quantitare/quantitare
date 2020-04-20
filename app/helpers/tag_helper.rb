# frozen_string_literal: true

# Random tag wrappers go here
module TagHelper
  def icon_tag(icon, **props)
    icon.tag(self, **props)
  end

  def fa_icon_tag(dom_classes, **props)
    icon_tag(Icon.for(:fa, name: dom_classes), **props)
  end

  def page_header_tag(text = nil, **props)
    content_tag(:div, **props.merge(class: 'row border-bottom pb-2 mb-3')) do
      content_tag(:div, class: 'col') do
        content_tag(:h2) { block_given? ? yield : text }
      end
    end
  end

  def section_header_2_tag(text)
    content_tag(:div, class: 'row pb-2') do
      content_tag(:div, class: 'col') do
        content_tag(:h3) { text }
      end
    end
  end

  def section_header_3_tag(text)
    content_tag(:div, class: 'row pb-2') do
      content_tag(:div, class: 'col') do
        content_tag(:h4, class: 'text-black-50') { text }
      end
    end
  end

  def form_group_tag(**props, &blk)
    content_tag(:div, class: add_dom_classes('form-group', props[:class]), data: props[:data] || {}, &blk)
  end
end

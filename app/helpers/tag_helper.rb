# frozen_string_literal: true

# Random tag wrappers go here
module TagHelper
  def icon_tag(icon_class, **options)
    icon_class ||= 'fas fa-question-circle'
    dom_class = add_dom_classes(options[:class], icon_class)

    content_tag :i, nil, class: dom_class
  end

  def page_header_tag(text = nil, **options)
    content_tag(:div, **options.merge(class: 'row border-bottom pb-2 mb-3')) do
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

  def form_group_tag(**options, &blk)
    content_tag(:div, class: add_dom_classes('form-group', options[:class]), data: options[:data] || {}, &blk)
  end
end

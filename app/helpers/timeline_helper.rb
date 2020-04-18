# frozen_string_literal: true

module TimelineHelper
  delegate :beginning_of_scale, :end_of_scale, :previous_date, :next_date, to: :date_scale

  def display_date
    case scale
    when 'day'
      date.strftime('%A, %-d %B %Y')
    when 'week'
      "#{date.beginning_of_week.strftime('%-d %B %Y')} - #{date.end_of_week.strftime('%-d %B %Y')}"
    when 'month'
      date.strftime('%B %Y')
    when 'year'
      date.strftime('%Y')
    end
  end

  def timeline_scale_nav_link(link_scale)
    link_to link_scale.titleize, root_path(scale: link_scale, date: date),
      class: "nav-item nav-link #{link_scale == scale ? 'active' : ''}".squish
  end

  def previous_date_path
    root_path(scale: scale, date: previous_date)
  end

  def next_date_path
    root_path(scale: scale, date: next_date)
  end

  def date_scale
    DateScale.new(date, scale)
  end

  def mapbox_tag(*)
    content_tag :div,
      data: {
        controller: 'mapbox',
        'mapbox-scrobbles-path': locations_url(format: :geojson, from: beginning_of_scale, to: end_of_scale)
      } do
        content_tag(:div, nil, class: 'timeline-map', data: { target: 'mapbox.map' })
      end
  end

  def highchart_tag(name, timeline_module)
    content_tag :div, nil,
      data: {
        controller: 'highchart',
        'highchart-path': timeline_module_path(timeline_module, date: date, scale: scale, name: name)
      }
  end

  def summary_tag(name, spec, timeline_module)
    content_tag :div,
      class: 'row',
      data: {
        controller: 'timeline-summary',
        'timeline-summary-path': timeline_module_path(timeline_module, date: date, scale: scale, name: name)
      } do
        spec.components.each do |component|
          concat(
            content_tag(
              :div,
              class: 'col',
              data: { target: 'timeline-summary.component', component: component }
            ) do
              concat(content_tag(:strong, nil, data: { attribute: 'total' }))
              concat(content_tag(:small, nil, data: { attribute: 'unit' }))
              concat(tag(:br))
              concat(content_tag(:span, nil, data: { attribute: 'label' }))
            end
          )
        end
      end
  end
end

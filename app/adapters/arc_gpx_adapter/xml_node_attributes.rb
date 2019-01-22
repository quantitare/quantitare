# frozen_string_literal: true

class ArcGPXAdapter
  ##
  # Extracts attributes from a GPX XML node.
  #
  class XMLNodeAttributes
    attr_reader :xml_node

    def initialize(xml_node)
      @xml_node = xml_node
    end

    def type
      case xml_node.name
      when 'wpt'
        ArcGPXAdapter::Placemark::T_PLACE
      when 'trk'
        ArcGPXAdapter::Placemark::T_TRANSIT
      end
    end

    def name
      value_from_path('name')
    end

    def category
      case type
      when ArcGPXAdapter::Placemark::T_PLACE
        nil
      when ArcGPXAdapter::Placemark::T_TRANSIT
        _category
      end
    end

    private

    def value_from_path(css_selector)
      xml_node.at_css(css_selector).try(:text)
    end

    def _category
      TRANSIT_CATEGORY_MAPPINGS[raw_category]
    end

    def raw_category
      value_from_path('type')
    end
  end
end

# frozen_string_literal: true

class ArcGPXAdapter
  ##
  # Extracts attributes from a GPX XML node
  #
  class XMLNodeAttributes
    attr_reader :xml_node

    def initialize(xml_node)
      @xml_node = xml_node
    end

    def type
      case xml_node.name
      when 'wpt'
        T_PLACE
      when 'trk'
        T_TRANSIT
      end
    end

    def name
      value_from_path('name')
    end

    def category
      case type
      when T_PLACE
        nil
      when T_TRANSIT
        process_input_category(raw_category)
      end
    end

    private

    def value_from_path(css_selector)
      xml_node.at_css(css_selector).text
    end

    def raw_category
      value_from_path('type')
    end
  end
end

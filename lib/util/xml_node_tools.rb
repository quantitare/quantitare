# frozen_string_literal: true

##
# Various tools for working with Nokogiri XML nodes
#
module Util
  module XMLNodeTools
    extend ActiveSupport::Concern

    def value_from_xml_path(xml_node, css_selector)
      xml_node.at_css(css_selector).try(:text)
    end

    def value_from_xml_node_attributes(xml_node, attribute_name)
      xml_node.attributes[attribute_name].value
    end

    def xml_value_exists?(xml_node, css_selector)
      xml_node.at_css(css_selector).present?
    end
  end
end

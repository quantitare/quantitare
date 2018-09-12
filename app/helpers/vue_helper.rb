# frozen_string_literal: true

##
# Helper methods related to adding Vue components to Rails views.
#
module VueHelper
  def vue_data_tag(opts = {})
    opts = opts.deep_dup.with_indifferent_access
    raise ArgumentError, 'Cannot set a class on a vue_data_tag' if opts[:class].present?

    opts.deep_merge!(class: 'd-none vue-data', 'v-if': 'false')

    content_tag(:div, opts) {}
  end
end

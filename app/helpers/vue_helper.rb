# frozen_string_literal: true

##
# Helper methods related to adding Vue components to Rails views.
#
module VueHelper
  def vue_data_tag(opts = {})
    opts = process_opts_for_vue_tag(opts, 'vue-data')

    content_tag(:div, opts) {}
  end

  def vuex_store_tag(store_name, opts = {})
    opts = process_opts_for_vue_tag(opts, 'vuex-store')
    opts.deep_merge!(data: { vuex_store: store_name.to_s.camelize(:lower) })

    content_tag(:div, opts) {}
  end

  def vuex_module_tag(module_name, opts = {})
    opts = process_opts_for_vue_tag(opts, 'vuex-module')
    opts.deep_merge!(data: { vuex_module: module_name.to_s.camelize(:lower) })

    content_tag(:div, opts) {}
  end

  private

  def process_opts_for_vue_tag(opts, vue_class_name)
    opts = opts.deep_dup.with_indifferent_access
    raise ArgumentError, 'Cannot set a class on this tag' if opts[:class].present?

    opts.deep_merge!(class: "d-none #{vue_class_name}", 'v-if': 'false')

    opts
  end
end

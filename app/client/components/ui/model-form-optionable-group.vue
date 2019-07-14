<template>
  <model-form-group :attribute="fullAttributeName" :layout="layout" :desc="desc">
    <template v-if="hasSelection" slot="fields">
      <model-form-choices
        :attribute="fullAttributeName"
        :options="selectionOptions"
        :multiple="selectMultiple"
        :params="selectParams"
        :default="options.default"
      ></model-form-choices>
    </template>
  </model-form-group>
</template>

<script>
export default {
  props: {
    options: Object,
    baseAttributeName: String,
    layout: { type: String, default: 'wide' },
  },

  data() {
    return {
      selectParams: { shouldSort: false }
    }
  },

  computed: {
    fullAttributeName() {
      return `${this.baseAttributeName}.${this.options.name}`
    },

    display() {
      return this.options.display
    },

    desc() {
      return this.display.desc
    },

    hasSelection() {
      return !!this.display.selection
    },

    selectionOptions() {
      return this.display.selection.map((item) => [item, item])
    },

    selectMultiple() {
      return this.options.type === 'array'
    },
  },
}
</script>

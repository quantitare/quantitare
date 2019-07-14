<template>
  <choices
    :value="value"
    @input="updateAttribute"
    @search="$emit('search', $event)"

    :id="fieldId"
    :name="fieldName"

    :params="params"
    :options="options"
    :multiple="multiple"

    :path="path"
    :pathDataFormatter="pathDataFormatter"

    :disabled="disabled"
  >
  </choices>
</template>

<script>
import railsFormField from 'mixins/rails-form-field';

export default {
  mixins: [railsFormField],

  props: {
    path: String,
    pathDataFormatter: Function,

    params: {
      type: Object,
      default() { return {}; },
    },

    options: {
      type: Array,
      default() { return []; },
    },

    multiple: Boolean,

    disabled: {
      type: Boolean,
      default: false
    }
  }
};
</script>

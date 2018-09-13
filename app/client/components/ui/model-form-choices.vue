<template>
  <choices
    :value="model[attribute]"
    @input="newValue"

    :id="fieldId"
    :name="fieldName"

    :params="params"
    :options="options"

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

    disabled: {
      type: Boolean,
      default: false
    }
  },

  computed: {
    value() {
      this.model[this.attribute]
    }
  },

  methods: {
    newValue(value) {
      this.model[this.attribute] = value;
    }
  }
};
</script>

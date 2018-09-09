<template>
  <choices
    v-model="model[attribute]"

    :id="fieldId"
    :name="fieldName"

    :params="params"
    :options="options"
    :value="value"

    :disabled="disabled"
  >
  </choices>
</template>

<script>
import railsFormField from 'mixins/rails-form-field';

export default {
  mixins: [railsFormField],

  props: { params: Object, options: Array, disabled: Boolean },

  computed: {
    value() {
      this.model[this.attribute]
    }
  }
};
</script>

<template>
  <input
    :value="model[attribute]"
    @input="updateAttribute($event.target.value)"

    :name="fieldName"
    :id="fieldId"
    :class="fieldClass"

    :disabled="disabled"
    :readonly="readonly"
  />
</template>

<script>
import railsFormField from 'mixins/rails-form-field';

export default {
  mixins: [railsFormField],

  props: {
    disabled: Boolean,
    readonly: Boolean
  }
};
</script>

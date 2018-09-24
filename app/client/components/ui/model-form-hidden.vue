<template>
  <input
    type="hidden"
    :value="value"

    :name="fieldName"
    :id="fieldId"
    :class="fieldClass"
  />
</template>

<script>
import railsFormField from 'mixins/rails-form-field';

export default {
  mixins: [railsFormField],
};
</script>

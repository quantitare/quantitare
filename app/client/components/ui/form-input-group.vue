<template>
  <form-group :attribute="attribute" :field-id="fieldId">
    <slot></slot>

    <template slot="field">
      <input
        v-model="model[attribute]"

        :name="fieldName"
        :id="fieldId"
        :class="fieldClass"

        :disabled="disabled"
        :readonly="readonly"
      />
    </template>
  </form-group>
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

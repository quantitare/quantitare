<template>
  <form-group :attribute="attribute" :field-id="fieldId">
    <slot></slot>

    <template slot="field">
      <choices
        :id="fieldId"
        :name="fieldName"

        :options="[]"
        :params="{}"
        :value="model[attribute]"
      >
      </choices>
    </template>
  </form-group>
</template>

<script>
import railsFormField from 'mixins/rails-form-field';
import choices from 'components/choices';

export default {
  mixins: [railsFormField],

  components: { choices },

  props: {
    disabled: Boolean,
  }
};
</script>

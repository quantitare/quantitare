<template>
  <div class="form-group row">
    <form-group-label v-if="label" :for="fieldId">
      <slot>{{ attribute }}</slot>
    </form-group-label>

    <div v-else class="col-sm-4"></div>

    <div class="col-sm-8">
      <slot name="fields" :model="model">
        <model-form-input
          :model="model"
          :scope="scope"
          :attribute="attribute"

          :disabled="disabled"
          :readonly="readonly"
        ></model-form-input>
      </slot>
    </div>
  </div>
</template>

<script>
import railsFormField from 'mixins/rails-form-field';

export default {
  mixins: [railsFormField],

  props: {
    label: {
      type: Boolean,
      default: true
    },

    disabled: Boolean,
    readonly: Boolean
  }
};
</script>

<template>
  <div class="form-control-plaintext custom-control custom-checkbox">
    <input
      :value="model[attribute]"
      @input="updateAttribute($event.target.checked)"

      type="checkbox"
      class="custom-control-input"

      :id="fieldId"
      :name="fieldName"
    />
    <label class="custom-control-label" :for="fieldId">
      <slot>{{ attribute }}</slot>
    </label>
  </div>
</template>

<script>
import railsFormField from 'mixins/rails-form-field';

export default {
  mixins: [railsFormField]
};
</script>

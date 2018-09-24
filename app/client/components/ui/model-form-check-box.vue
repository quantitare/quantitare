<template>
  <div class="form-control-plaintext custom-control custom-checkbox">
    <input type="hidden" :name="fieldName" :value="false" />
    <input
      :checked="value"
      :value="value"
      @input="handleInput"

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
import reactiveFormField from 'mixins/reactive-form-field';

export default {
  mixins: [railsFormField, reactiveFormField],

  props: {
    reactive: {
      type: Boolean,
      default: false
    }
  },

  methods: {
    handleInput(event) {
      const vm = this;

      this.updateAttribute(event.target.checked)
        .then(() => {
          vm.$nextTick(() => {
            if (vm.reactive) vm.submitField();
          });
        })
    }
  }
};
</script>

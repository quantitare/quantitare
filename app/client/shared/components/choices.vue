<template>
  <select v-bind:id="id" v-bind:name="name" v-on:change="selectionChanged"></select>
</template>

<script>
import * as Choices from 'choices.js/assets/scripts/dist/choices.min';
import _ from 'lodash';
import 'choices.js/assets/styles/scss/choices';

export default {
  name: 'choices',
  props: { id: String, name: String, params: Object, value: String, options: Array },

  computed: {
    choicesOptions() {
      const vm = this;
      const placeholder = [{ value: null, label: 'Please make a selection', selected: !vm.value, disabled: true }];

      return placeholder.concat(this.options.map((pair) => {
        return {
          value: pair[1],
          label: pair[0],
          selected: pair[1] === vm.value
        };
      }));
    }
  },

  methods: {
    selectionChanged(event) {
      this.$emit('input', event.detail.value);
    }
  },

  mounted() {
    const defaultParams = {
      itemSelectText: '',
      placeholder: true,

      choices: this.choicesOptions,

      classNames: {
        containerOuter: 'choices',
        containerInner: 'form-control',
      }
    };

    const mergedParams = _.merge(defaultParams, this.params);
    this.choices = new Choices(`#${this.id}`, mergedParams);

    this.$emit('input', this.value);
  }
};
</script>

<style lang="scss">
.choices {
  display: block;
  width: 100%;
}

.is-open .choices__list--dropdown {
  margin-top: 3px;

  border: 1px solid #ced4da;
  border-top-left-radius: 0.25rem;
  border-top-right-radius: 0.25rem;
  border-bottom-right-radius: 0.25rem;
  border-bottom-left-radius: 0.25rem;
}
</style>

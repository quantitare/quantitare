<template>
  <select :id="id" :name="name" :disabled="disabled" @change="$emit('input', $event.detail.value)"></select>
</template>

<script>
import * as Choices from 'choices.js/assets/scripts/dist/choices';
import _ from 'lodash';
import 'choices.js/assets/styles/scss/choices';

export default {
  name: 'choices',
  props: {
    id: String,
    name: String,
    value: null,

    params: {
      type: Object,
      default() { return {}; }
    },

    path: String,
    pathDataFormatter: {
      type: Function,
      default(obj) { return obj; }
    },

    options: {
      type: Array,
      default() { return []; }
    },

    disabled: Boolean
  },

  data() {
    return {
      choices: null,

      placeholderOption: [{ value: null, label: 'Please make a selection', selected: this.value, disabled: true }]
    };
  },

  computed: {
    choicesOptions() {
      if (this.path) return [];

      const vm = this;

      return this.placeholderOption.concat(this.options.map((pair) => {
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
    },

    fetchOptionsFromPath() {
      const vm = this;

      this.choices.ajax(function(callback) {
        fetch(vm.path)
          .then(function(response) {
            response.json().then(function(data) {
              const formattedData = _.map(data, vm.pathDataFormatter);
              callback(formattedData, 'value', 'label');
              if (!_.isNil(vm.value)) vm.choices.setValueByChoice(vm.value);
            });
          })
          .catch(function(error) {
            console.log(error);
          });
      });
    }
  },

  watch: {
    disabled(newValue) {
      if (newValue) {
        this.choices.disable();
      } else {
        this.choices.enable();
      }
    },
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

    let mergedParams = _.merge(defaultParams, this.params);
    this.choices = new Choices(`#${this.id}`, mergedParams);

    if (this.path) this.fetchOptionsFromPath();
  }
};
</script>

<style lang="scss">
.choices {
  display: block;
  width: 100%;
}

.choices__list.choices__list--single {
  padding: 0px;
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

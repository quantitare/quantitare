<template>
  <select :id="id" :name="name" :disabled="disabled" @search="$emit('search', $event)">
    <slot>
      <option value="" placeholder>Make a selection...</option>
    </slot>
  </select>
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
      choices: null
    };
  },

  computed: {
    choicesOptions() {
      if (this.path) return [];

      const vm = this;

      return this.options.map((pair) => {
        return {
          value: pair[1],
          label: pair[0],
          selected: pair[1] === vm.value
        };
      });
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
              vm.choices.setValueByChoice(vm.value);
            });
          })
          .catch(function(error) {
            console.log(error); // TODO
          });
      });
    },

    changed(event) {
      const value = event.detail.value
      this.$emit('input', value);
    }
  },

  watch: {
    disabled(newValue) {
      if (newValue) {
        this.choices.disable();
      } else {
        this.choices.enable();
      }
    }
  },

  mounted() {
    const defaultParams = {
      itemSelectText: '',
      placeholder: true,
      removeItemButton: true,
      duplicateItems: false,

      choices: this.choicesOptions,

      classNames: {
        containerOuter: 'choices',
        containerInner: 'form-control',
      }
    };

    let mergedParams = _.merge(defaultParams, this.params);
    const el = document.getElementById(this.id);
    this.choices = new Choices(el, mergedParams);
    el.addEventListener('addItem', this.changed);

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

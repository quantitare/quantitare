<template>
  <select :id="id" :name="name" :disabled="disabled" v-model="myValue" @search="$emit('search', $event)" :multiple="multiple">
    <slot></slot>
  </select>
</template>

<script>
import * as Choices from 'choices.js/public/assets/scripts/choices';
import _ from 'lodash';
import 'choices.js/public/assets/styles/choices';

export default {
  name: 'choices',
  props: {
    id: String,
    name: String,
    value: null,
    multiple: Boolean,

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

    disabled: Boolean,
  },

  data() {
    return {
      choices: null,
      myValue: null
    };
  },

  computed: {
    choicesOptions() {
      if (this.path) return [];

      return this.options.map((pair) => {
        return pair instanceof Array ? this.arrayOptions(pair) : this.objectOptions(pair)
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
              vm.choices.setChoiceByValue(vm.value);
            });
          })
          .catch(function(error) {
            console.log(error); // TODO
          });
      });
    },

    arrayOptions(pair) {
      return {
        value: pair[1],
        label: pair[0],
        selected: this.shouldSelectValue(pair[1])
      }
    },

    objectOptions(pair) {
      return _.extend({ selected: this.shouldSelectValue(pair.value) }, pair)
    },

    shouldSelectValue(targetValue) {
      return this.multiple ? this.value.includes(targetValue) : this.value === targetValue
    },
  },

  watch: {
    myValue() {
      this.$emit('input', this.myValue);
    },

    disabled(newValue) {
      if (newValue) {
        this.choices.disable();
      } else {
        this.choices.enable();
      }
    },
  },

  created() {
    this.myValue = this.value
  },

  mounted() {
    const defaultParams = {
      itemSelectText: '',
      placeholder: true,
      removeItemButton: true,
      duplicateItemsAllowed: false,

      choices: this.choicesOptions,

      classNames: {
        containerOuter: 'choices',
        containerInner: 'form-control',
      }
    };

    let mergedParams = _.merge(defaultParams, this.params);
    const el = document.getElementById(this.id);
    this.choices = new Choices(el, mergedParams);

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

.choices__input {
  background-color: #fff;
}

[data-type="select-multiple"] .form-control {
  padding-bottom: 0px;
}
</style>

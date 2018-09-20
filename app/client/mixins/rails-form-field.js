import _ from 'lodash';
import { mapActions } from 'vuex';

export default {
  inject: ['namespace', 'model', 'scope'],

  props: {
    attribute: String,
  },

  computed: {
    updateActionName() {
      const prefix = this.namespace ? `${this.namespace}/` : ''
      return `${prefix}update${_.upperFirst(this.attribute)}`;
    },

    fieldId() {
      return `${_.snakeCase(this.scope)}_${_.snakeCase(this.attribute)}`;
    },

    fieldName() {
      return `${_.snakeCase(this.scope)}[${_.snakeCase(this.attribute)}]`
    },

    fieldClass() {
      const classes = [];

      if (this.readonly) {
        classes.push('form-control-plaintext');
      } else {
        classes.push('form-control');
      }

      if (this.model.errors && this.model.errors[this.attribute]) classes.push('is-invalid');

      return _.join(classes, ' ');
    },

    attributeErrors() {
      return this.model.errors && this.model.errors[this.attribute];
    }
  },

  methods: {
    updateAttribute(value) {
      this.$store.dispatch(this.updateActionName, value);
    }
  }
};

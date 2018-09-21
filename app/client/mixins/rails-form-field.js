import _ from 'lodash';

export default {
  inject: ['model', 'scope'],

  props: {
    attribute: String,
  },

  computed: {
    updateActionName() {
      return `update${_.upperFirst(this.scope)}`;
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
      this.$store.dispatch(this.updateActionName, { [this.attribute]: value });
    }
  }
};

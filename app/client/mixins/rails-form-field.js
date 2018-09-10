export default {
  props: {
    attribute: String,
    scope: String,
    model: Object
  },

  computed: {
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
  }
};

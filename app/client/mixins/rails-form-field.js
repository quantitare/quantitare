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
      if (this.readonly) {
        return 'form-control-plaintext'
      } else {
        return 'form-control'
      }
    }
  }
};

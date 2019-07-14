import _ from 'lodash';

export default {
  inject: ['model', 'scope'],

  props: {
    model: {
      default() {
        return this.model
      }
    },

    scope: {
      default() {
        return this.scope
      }
    },

    attribute: String,
  },

  computed: {
    value() {
      return  _.get(this.model, this.attribute);
    },

    updateActionName() {
      return `update${_.upperFirst(this.scope)}`;
    },

    fieldId() {
      return `${_.snakeCase(this.scope)}_${_.snakeCase(this.attribute)}`;
    },

    fieldName() {
      return `${_.snakeCase(this.scope)}${this.attributeNesting}`
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
    },

    attributeNesting() {
      const nestings = this.attribute.split('.');

      return nestings.map((node) => `[${_.snakeCase(node)}]`).join('');
    }
  },

  methods: {
    updateAttribute(value) {
      return this.$store.dispatch(this.updateActionName, { [this.attribute]: value });
    }
  }
};

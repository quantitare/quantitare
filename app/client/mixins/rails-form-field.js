import _ from 'lodash';

export default {
  inject: ['model', 'scope'],

  props: {
    attribute: String,
    default: null,
  },

  computed: {
    value() {
      return this.attributeOnModel === undefined ? this.default : this.attributeOnModel
    },

    attributeOnModel() {
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
      const nestings = this.attribute.split('.')
      const base = nestings.map((node) => `[${_.snakeCase(node)}]`).join('')
      const append = this.value instanceof Array ? '[]' : ''

      return `${base}${append}`
    }
  },

  methods: {
    updateAttribute(value) {
      return this.$store.dispatch(this.updateActionName, { [this.attribute]: value });
    }
  }
};

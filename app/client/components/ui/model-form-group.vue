<template>
  <div class="form-group row">
    <form-group-label v-if="label" :for="fieldId" :layout="layout">
      <slot>{{ friendlyAttribute }}</slot>
    </form-group-label>

    <div v-else class="col-sm-4"></div>

    <with-root :show="wideLayout">
      <div class="col-sm-8">
        <slot name="fields" :model="model">
          <model-form-input :attribute="attribute" :disabled="disabled" :readonly="readonly" :input-type="inputType">
          </model-form-input>
        </slot>

        <div v-for="error in attributeErrors" class="invalid-feedback">{{ error }}</div>
        <small v-if="desc" class="form-text text-muted">{{ desc }}</small>
      </div>
    </with-root>
  </div>
</template>

<script>
import railsFormField from 'mixins/rails-form-field'
import S from 'string'

export default {
  mixins: [railsFormField],

  props: {
    label: {
      type: Boolean,
      default: true
    },

    desc: String,

    inputType: { type: String, default: 'text' },

    disabled: Boolean,
    readonly: Boolean,

    layout: { type: String, default: 'wide' }
  },

  computed: {
    relativeAttribute() {
      return _.last(this.attribute.split('.'))
    },

    friendlyAttribute() {
      return S(this.relativeAttribute).humanize().s
    },

    wideLayout() {
      return this.layout !== 'narrow'
    }
  }
};
</script>

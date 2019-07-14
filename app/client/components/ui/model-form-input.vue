<template>
  <input
    :value="displayableValue"
    @input="updateAttribute($event.target.value)"

    :type="inputType"
    :name="fieldName"
    :id="fieldId"
    :class="fieldClass"

    :disabled="disabled"
    :readonly="readonly"
  />
</template>

<script>
import railsFormField from 'mixins/rails-form-field'
import { DateTime } from 'luxon'

export default {
  mixins: [railsFormField],

  props: {
    inputType: { type: String, default: 'text' },

    disabled: Boolean,
    readonly: Boolean
  },

  computed: {
    displayableValue() {
      switch  (this.inputType) {
        case 'datetime-local':
          return DateTime.fromISO(this.value).toISO({
            suppressMilliseconds: true, suppressSeconds: true, includeOffset: false
          })
        default:
          return this.value
      }
    }
  }
};
</script>

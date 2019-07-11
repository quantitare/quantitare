<template>
  <model-form :model="model" scope="service">
    <model-form-hidden attribute="provider" />
    <model-form-group attribute="name">Name</model-form-group>

    <div v-for="field in providerFields">
      <model-form-group :attribute="field.attribute">{{ field.label }}</model-form-group>
    </div>

    <form-group>
      <template slot="field">
        <model-form-submit />
        <button type="button" class=" btn btn-link" @click="clearService">Cancel</button>
      </template>
    </form-group>
  </model-form>
</template>

<script>
import { mapGetters, mapActions } from 'vuex'
import _ from 'lodash'
import S from 'string'

export default {
  computed: {
    providerFields() {
      const fields = this.model.providerOptions.fields || {}

      const val = _.keys(fields).map((key) => {
        return {
          attribute: key,
          label: S(fields[key].as || key).humanize().s,
        }
      })

      return val
    },

    ...mapGetters('service', ['model']),
  },

  methods: {
    ...mapActions(['clearService']),
  }
}
</script>

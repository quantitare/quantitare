<template>
  <div class="col-md-6 pr-5">
    <div class="row d-flex justify-content-end">
      <div class="custom-control custom-switch">
        <input v-model="showAdvanced" type="checkbox" class="custom-control-input" id="show_advanced">
        <label for="show_advanced" class="custom-control-label">Advanced</label>
      </div>
    </div>

    <model-form :model="model" scope="scrobbler">
      <model-form-group v-if="model.isNewRecord" attribute="type" layout="narrow">
        <template slot="fields">
          <model-form-choices attribute="type" :options="availableTypeOptions"></model-form-choices>
        </template>
      </model-form-group>

      <div v-if="scrobblerMetadata.ready" class="scrobbler-options">
        <model-form-group attribute="name" layout="narrow"></model-form-group>

        <model-form-group v-if="scrobblerMetadata.requiresProvider" attribute="serviceId" layout="narrow">
          <template slot="fields">
            <model-form-choices
              attribute="serviceId"
              :options="scrobblerMetadata.providerOptions"
            ></model-form-choices>
          </template>
        </model-form-group>

        <model-form-optionable-group
          v-for="option in scrobblerMetadata.options"
          :key="option.name"
          :options="option"
          base-attribute-name="options"
          layout="narrow"
        ></model-form-optionable-group>

        <div v-if="showAdvanced" id="advanced">
          <model-form-group
            attribute="earliestDataAt" layout="narrow" inputType="datetime-local" :desc="earliestDataAtDesc"
          ></model-form-group>

          <div class="row">
            <page-subheader-2 :cozy="true">Schedules</page-subheader-2>
          </div>

          <div class="row">
            <div class="col"><scrobbler-schedule-field :metadata="scrobblerMetadata" schedule="shallow" /></div>
            <div class="col"><scrobbler-schedule-field :metadata="scrobblerMetadata" schedule="medium" /></div>
          </div>

          <div class="row">
            <div class="col"><scrobbler-schedule-field :metadata="scrobblerMetadata" schedule="deep" /></div>
            <div class="col"><scrobbler-schedule-field :metadata="scrobblerMetadata" schedule="full" /></div>
          </div>
        </div>

        <div class="row"><model-form-submit /></div>
      </div>
    </model-form>
  </div>
</template>

<script>
import { mapGetters, mapActions } from 'vuex'

export default {
  props: {
    availableTypeOptions: { type: Array, default: () => { return [] } }
  },

  data() {
    return {
      scrobblerMetadata: {
        ready: false
      },

      showAdvanced: false,

      earliestDataAtDesc: 'The earliest date for which you expect the service to have data.'
    }
  },

  computed: {
    ...mapGetters('scrobbler', ['model'])
  },

  methods: {
    loadTypeOptions(type) {
      this.$http.get('/scrobblers/type_data', { params: { type: type, scrobbler_id: this.model.id } }).then(
        (response) => {
          this.updateScrobbler(response.body.scrobbler)
            .then(() => this.scrobblerMetadata = response.body)
        },

        (response) => {
          console.log('oops') // TODO: Handle HTTP errors better
        }
      )
    },

    ...mapActions(['updateScrobbler'])
  },

  mounted() {
    this.loadTypeOptions(this.model.type)

    this.$watch('model.type', (newVal, oldVal) => {
      if (newVal !== oldVal) this.loadTypeOptions(newVal)
    })
  }
}
</script>

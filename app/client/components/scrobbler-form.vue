<template>
  <div class="col-md-6 pr-5">
    <div class="row d-flex justify-content-end">
      <div class="custom-control custom-switch">
        <input v-model="showAdvanced" type="checkbox" class="custom-control-input" id="show_advanced">
        <label for="show_advanced" class="custom-control-label">Advanced</label>
      </div>
    </div>

    <model-form :model="model" scope="scrobbler">
      <model-form-group v-if="model.isNewRecord" attribute="type" layout="narrow"></model-form-group>

      <model-form-group attribute="name" layout="narrow"></model-form-group>

      <div v-if="scrobblerMetadata.ready" class="scrobbler-options">
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
          :model="model.options"
          base-attribute-name="options"
          layout="narrow"
        ></model-form-optionable-group>

        <div v-if="showAdvanced" id="advanced">
          <model-form-group attribute="earliestDataAt" layout="narrow" inputType="datetime-local"></model-form-group>
        </div>

        <div class="row"><model-form-submit /></div>
      </div>
    </model-form>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'

export default {
  data() {
    return {
      scrobblerMetadata: {
        ready: false
      },

      showAdvanced: false
    }
  },

  computed: {
    ...mapGetters('scrobbler', ['model'])
  },

  methods: {
    loadTypeOptions(type) {
      this.$http.get('/scrobblers/type_data', { params: { type: type, scrobbler_id: this.model.id } }).then(
        (response) => {
          this.scrobblerMetadata = response.body
        },

        (response) => {
          console.log('oops') // TODO: Handle HTTP errors better
        }
      )
    }
  },

  mounted() {
    this.loadTypeOptions(this.model.type)
  }
}

// import choices from 'components/choices';
// import modelErrors from 'components/model-errors';

// export default {
//   components: { choices, modelErrors },

//   props: {
//     scrobbler: Object,
//   },

//   data() {
//     return {
//       scrobblerMetadata: {
//         ready: false
//       }
//     };
//   },

//   methods: {
//     typeChanged(value) {
//       this.scrobbler.type = value;
//       this.loadTypeOptions(this.scrobbler.type);
//     },

//     loadTypeOptions(type) {
//       this.$http.get('/scrobblers/type_data', { params: { type: type, scrobbler_id: this.scrobbler.id } }).then(
//         (response) => {
//           this.scrobblerMetadata = response.body

//           if (!response.body.scrobbler) return

//           _.keys(response.body.scrobbler).forEach((key) => this.$set(this.scrobbler, key, response.body.scrobbler[key]))
//         },

//         (response) => {
//           console.log('oops'); // TODO: Display some error message.
//         }
//       );
//     }
//   },

//   mounted() {
//     this.loadTypeOptions(this.scrobbler.type);
//   }
// };
</script>

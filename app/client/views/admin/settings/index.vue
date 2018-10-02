<template>
  <div>
    <page-header>Admin Settings</page-header>

    <page-body>
      <body-section width="9">
        <form-group field-id="settings_place_service_id">
          Place metadata service

          <template slot="field">
            <reactive-select id="settings_place_service_id" action="/admin/settings/place_service_id" name="value">
              <option placeholder></option>
              <option
                v-for="service in placeServices"

                :value="service.value"
                :selected="settings.place_service_id === service.value"
              >
                {{ service.label }}
              </option>
            </reactive-select>
          </template>
        </form-group>
      </body-section>
    </page-body>
  </div>
</template>

<script>
import { mapState } from 'vuex';
import Vue from 'vue/dist/vue.esm';
import _ from 'lodash';

export default {
  data() {
    return {
      placeServices: []
    };
  },

  computed: {
    ...mapState(['settings'])
  },

  methods: {
    fetchPlaceServices() {
      const vm = this;

      Vue.http.get('/services/search?for_place_metadata=true').then((response) => {
        vm.placeServices = response.body.map((service) => {
          return { label: `${_.capitalize(service.provider)} - ${service.name}`, value: service.id.toString() };
        });
      }, () => {
        console.log('oops'); // TODO
      });
    }
  },

  created() {
    this.fetchPlaceServices();
  }
};
</script>

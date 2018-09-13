<template>
  <div>
    <page-header>
      <header-icon :icon="model.icon || 'map-marker-alt'" />
      {{ model.name }}
      <small class="text-muted">{{ model.category }}</small>
    </page-header>

    <page-body>
      <body-section width="9">
        <div class="row">
          <p>
            <span v-if="model.isTransit">{{ model.distance }} <i>from</i></span>
            {{ model.startAtDisplay }} <i class="text-muted">to</i> {{ model.endAtDisplay }}
            &middot; {{ model.durationDisplay }}
          </p>
        </div>

        <location-scrobble-form
          v-bind.sync="locationScrobble"
          :model="model"
          :place-edit-mode="placeEditMode"

          @place-edit-mode-set="setPlaceEditMode"
        >
        </location-scrobble-form>

        <place-form :place="locationScrobble.place" :errors="[]" v-if="placeEditMode !== 'closed'">
        </place-form>
      </body-section width="9">
    </page-body>
  </div>
</template>

<script>
import LocationScrobble from 'models/location-scrobble';

const PE_CLOSED = 'closed';
const PE_NEW = 'new';
const PE_EDIT = 'edit';
const PE_CHANGE = 'change';

const PLACE_EDIT_MODES = [PE_CLOSED, PE_NEW, PE_EDIT, PE_CHANGE];

export default {
  props: {
    locationScrobble: Object,
    errors: Array
  },

  data() {
    return {
      placeEditMode: PE_CLOSED
    };
  },

  computed: {
    model() {
      return _.extend(new LocationScrobble, this.locationScrobble);
    }
  },

  watch: {
    placeId(val) {
      const path = val ? `/places/${val}` : '/places/new';

      this.fetchPlace(path);
    }
  },

  methods: {
    fetchPlace(path) {
      const vm = this;

      this.$http.get(path).then((response) => {
        this.place = response.body;
      }, (response) => {
        console.log('oops'); // TODO
      });
    },

    setPlaceEditMode(val) {
      switch (val) {
        case PE_CLOSED:
          break;
        case PE_NEW:
          this.fillNewPlaceFields();
          break;
        case PE_EDIT:
          break;
      }

      this.placeEditMode = val;
    },

    fillNewPlaceFields() {
      if (!this.model.place.isNewRecord) return;

      this.model.place.name = this.model.name;
      this.model.place.latitude = this.model.averageLatitude;
      this.model.place.longitude = this.model.averageLongitude;
    }
  }
};
</script>

<style lang="scss">
</style>

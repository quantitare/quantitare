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
          :location-scrobble="model"
          :errors="errors"
          :place-edit="placeEdit"

          @toggle-place-edit="togglePlaceEdit"
        >
        </location-scrobble-form>

        <place-form :place="model.place" :errors="[]" v-if="placeEdit">
        </place-form>
      </body-section width="9">
    </page-body>
  </div>
</template>

<script>
import LocationScrobble from 'models/location-scrobble';

export default {
  props: {
    locationScrobble: Object,
    errors: Array
  },

  data() {
    return {
      placeEdit: false
    };
  },

  computed: {
    model() {
      return _.extend(new LocationScrobble, this.locationScrobble);
    }
  },

  methods: {
    togglePlaceEdit(val) {
      if (val) this.fillPlaceFields();

      this.placeEdit = val;
    },

    fillPlaceFields() {
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

<template>
  <div>
    <page-header>
      <header-icon icon="map-marker-alt" />
      {{ locationScrobble.name }}

      <small class="text-muted">
        <span v-if="locationScrobble.isTransit">{{ locationScrobble.distance }}</span>
        <i>from</i> {{ locationScrobble.startTime }} <i>to</i> {{ locationScrobble.endTime }}
      </small>
    </page-header>

    <page-body>
      <body-section width="9">
        <location-scrobble-form
          :location-scrobble="locationScrobble"
          :errors="errors"
          :place-edit="placeEdit"

          @toggle-place-edit="placeEdit = $event"
        >
        </location-scrobble-form>

        <place-form :place="locationScrobble.place" :errors="[]" v-if="placeEdit">
        </place-form>
      </body-section width="9">
    </page-body>
  </div>
</template>

<script>
export default {
  props: {
    locationScrobble: Object,
    errors: Array
  },

  data() {
    return {
      placeEdit: false
    };
  }
};
</script>

<style lang="scss">
</style>

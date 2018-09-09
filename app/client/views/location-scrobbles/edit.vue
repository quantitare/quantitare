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
        <location-scrobble-form :location-scrobble="locationScrobble" :errors="errors">
        </location-scrobble-form>
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
};
</script>

<style lang="scss">
</style>

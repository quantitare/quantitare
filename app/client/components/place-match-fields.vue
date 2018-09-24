<template>
  <model-form-fields :model="placeMatch" scope="placeMatch">
    <page-subheader-2>Match options</page-subheader-2>

    <model-form-group attribute="enabled">
      &nbsp;

      <template slot="fields">
        <model-form-check-box attribute="enabled">
          Match similar location scrobbles from this source to this place
        </model-form-check-box>
      </template>
    </model-form-group>

    <model-form-group v-if="placeMatch.enabled">
      Match attributes

      <template slot="fields">
        <model-form-check-box attribute="matchName">
          Name <span class="text-muted">«{{ locationScrobble.name }}»</span>
        </model-form-check-box>

        <model-form-check-box attribute="matchCoordinates">
          Coordinates
          <span class="text-muted">
            «{{ locationScrobble.averageLongitude }}, {{ locationScrobble.averageLatitude }}»
          </span>
        </model-form-check-box>

        <model-form-hidden v-if="placeMatch.matchName" attribute="sourceFields.name" />
        <model-form-hidden v-if="placeMatch.matchCoordinates" attribute="sourceFields.longitude" />
        <model-form-hidden v-if="placeMatch.matchCoordinates" attribute="sourceFields.latitude" />
      </template>
    </model-form-group>
  </model-form-fields>
</template>

<script>
import { mapState, mapGetters } from 'vuex';

export default {
  computed: {
    ...mapState(['placeMatch', 'locationScrobble']),
    ...mapGetters('placeMatch', ['sourceFields'])
  }
};
</script>

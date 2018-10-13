<template>
  <model-form-fields :model="placeMatch" scope="placeMatch">
    <page-subheader-2>Match options</page-subheader-2>

    <model-form-group attribute="enabled">
      &nbsp;

      <template slot="fields">
        <model-form-check-box attribute="enabled" :disabled="!canSetPlaceMatchOptions">
          Match similar location scrobbles from this source to this place
        </model-form-check-box>
      </template>
    </model-form-group>

    <model-form-group v-if="placeMatch.enabled && canSetPlaceMatchOptions">
      Match attributes

      <template slot="fields">
        <model-form-check-box attribute="matchName">
          Name <span class="text-muted">«{{ locationScrobble.originalName }}»</span>
        </model-form-check-box>

        <model-form-check-box attribute="matchCoordinates" :disabled="true">
          Coordinates
          <span class="text-muted">
            «{{ locationScrobble.averageLongitude }}, {{ locationScrobble.averageLatitude }}»
          </span>
        </model-form-check-box>

        <model-form-hidden
          v-if="placeMatch.matchName"
          :value="sourceFields.name"
          attribute="sourceFields.name"
        />

        <model-form-hidden
          :value="sourceFields.longitude"
          attribute="sourceFields.longitude"
        />

        <model-form-hidden
          :value="sourceFields.latitude"
          attribute="sourceFields.latitude"
        />
      </template>
    </model-form-group>
  </model-form-fields>
</template>

<script>
import { mapState, mapGetters } from 'vuex';

export default {
  computed: {
    canSetPlaceMatchOptions() {
      return this.placeMatch.isNewRecord || this.locationScrobble.placeId != this.locationScrobble._original.placeId;
    },

    ...mapState(['placeMatch', 'locationScrobble']),
    ...mapGetters('placeMatch', ['sourceFields'])
  }
};
</script>

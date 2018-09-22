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
          :model="locationScrobble"
          scope="locationScrobble"
        >
        </location-scrobble-form>

        <place-form v-if="placeEdit">
        </place-form>
      </body-section width="9">
    </page-body>
  </div>
</template>

<script>
import { mapState, mapGetters, mapActions } from 'vuex';
import LocationScrobble from 'models/location-scrobble';

const PE_CLOSED = 'closed';
const PE_NEW = 'new';
const PE_EDIT = 'edit';
const PE_CHANGE = 'change';

const PLACE_EDIT_MODES = [PE_CLOSED, PE_NEW, PE_EDIT, PE_CHANGE];

export default {
  computed: {
    ...mapState(['placeEdit', 'locationScrobble', 'place']),

    ...mapGetters(['placeEditMode']),
    ...mapGetters('locationScrobble', ['model'])
  },

  methods: {
    ...mapActions(['setPlaceEdit', 'cacheOriginals', 'processPlaceId']),
  },

  watch: {
    'locationScrobble.placeId'() {
      this.processPlaceId();
    }
  },

  created() {
    this.processPlaceId();
    this.cacheOriginals();
  }
};
</script>

<style lang="scss">
</style>

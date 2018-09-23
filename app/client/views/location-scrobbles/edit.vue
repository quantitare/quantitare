<template>
  <div>
    <page-header v-if="nameEdit" class="d-block">
      <model-form :model="locationScrobble" scope="locationScrobble">
        <div class="input-group input-group-lg">
          <div class="input-group-prepend">
            <span class="input-group-text"><font-awesome-icon :icon="model.icon || 'map-marker-alt'" /></span>
          </div>

          <model-form-input attribute="name"></model-form-input>

          <div class="input-group-append">
            <button class="btn btn-outline-success" type="button">
              <font-awesome-icon icon="check" />
            </button>
            <button class="btn btn-outline-danger" type="button" @click="cancelNameEdit">
              <font-awesome-icon icon="times" />
            </button>
          </div>
        </div>
      </model-form>
    </page-header>

    <page-header v-else>
      <header-icon :icon="model.icon || 'map-marker-alt'" />

      <span @click="startNameEdit">{{ model.name }}</span>
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
          <template slot="additional-fields">
            <input type="hidden" name="location_scrobble_id" :value="locationScrobble.id" />
          </template>
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
  data() {
    return {
      nameEdit: false
    };
  },

  computed: {
    canEditName() {
      return this.model.singular;
    },

    ...mapState(['placeEdit', 'locationScrobble', 'place']),

    ...mapGetters(['placeEditMode']),
    ...mapGetters('locationScrobble', ['model'])
  },

  methods: {
    startNameEdit() {
      if (!this.canEditName) return;

      this.nameEdit = true;
    },

    cancelNameEdit() {
      this.nameEdit = false;
    },

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

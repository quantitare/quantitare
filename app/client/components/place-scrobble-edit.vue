<template>
  <div>
    <page-header v-if="nameEdit" class="d-block">
      <model-form :model="locationScrobble" scope="locationScrobble">
        <div class="input-group input-group-lg">
          <div class="input-group-prepend">
            <span class="input-group-text"><icon :icon="model.icon" /></span>
          </div>

          <model-form-input attribute="name"></model-form-input>

          <div class="input-group-append">
            <button class="btn btn-outline-success" type="submit" @click="closeNameEdit">
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
      <header-icon :icon="model.icon" />

      <span @click="startNameEdit">{{ model.name }}</span>
      <small class="text-muted">{{ model.category }}</small>
    </page-header>

    <page-body>
      <body-section width="9">
        <location-scrobble-descriptor :model="model"></location-scrobble-descriptor>

        <place-scrobble-form
          :model="locationScrobble"
          :placeable="placeable"
          scope="locationScrobble"
        >
        </place-scrobble-form>

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
      return !this.placeable;
    },

    placeable() {
      return !this.model.singular;
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

    closeNameEdit() {
      this.nameEdit = false;
    },

    cancelNameEdit() {
      this.restoreOriginal({ name: true });
      this.closeNameEdit();
    },

    ...mapActions(['setPlaceEdit', 'cacheOriginals', 'processPlaceId']),
    ...mapActions('locationScrobble', ['restoreOriginal'])
  },

  watch: {
    'locationScrobble.placeId'() {
      this.processPlaceId();
    }
  },

  created() {
    this.processPlaceId();
  }
};
</script>

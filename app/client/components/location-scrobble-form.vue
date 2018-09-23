<template>
  <model-form :model="model" scope="locationScrobble">
    <div>
      <page-subheader-1>Options</page-subheader-1>

      <model-form-group>
        &nbsp;

        <template slot="fields">
          <model-form-check-box :reactive="true" attribute="singular" class="custom-control-inline">
            This is a one-time stop (e.g. "Stuck in traffic")
          </model-form-check-box>
        </template>
      </model-form-group>
    </div>

    <div v-if="model.isPlace">
      <page-subheader-1>Place info</page-subheader-1>

      <model-form-group attribute="placeId">
        Choose a place

        <template slot="fields">
          <div class="row">
            <div class="col-sm-9">
              <model-form-choices
                attribute="placeId"

                path="/places/search.json"
                :pathDataFormatter="placesPathDataFormatter"
                :disabled="placeEdit"
              >
              </model-form-choices>
            </div>

            <div class="col-sm-3">
              <button
                v-if="canSubmit"
                type="submit"
                class="btn btn-outline-success form-control"
              >
                <font-awesome-icon icon="check"></font-awesome-icon>
              </button>

              <button
                v-else-if="!placeEdit && !model.placeId"
                class="btn btn-outline-success form-control"

                @click.prevent="openPlaceEdit('new')"
              >
                <font-awesome-icon icon="plus"></font-awesome-icon>
              </button>

              <div v-else-if="!placeEdit" class="btn-group" role="group" aria-label="Place edit options">
                <button
                  type="button"
                  class="btn btn-outline-primary"

                  @click.prevent="openPlaceEdit('edit')"
                >
                  <font-awesome-icon icon="pencil-alt"></font-awesome-icon>
                </button>
                <button
                  type="button"
                  class="btn btn-outline-success"

                  @click.prevent="openPlaceEdit('new')"
                >
                  <font-awesome-icon icon="plus"></font-awesome-icon>
                </button>
              </div>

              <button
                v-else
                class="btn btn-outline-danger form-control"

                @click.prevent="closePlaceEdit"
              >
                <font-awesome-icon icon="times"></font-awesome-icon>
              </button>
            </div>
          </div>
        </template>
      </model-form-group>
    </div>
  </model-form>
</template>

<script>
import { mapState, mapGetters, mapActions } from 'vuex';

export default {
  props: {
    model: Object,
  },

  computed: {
    canSubmit() {
      return !this.placeEdit && this.model.placeId !== this.model._original.placeId;
    },

    ...mapState(['placeEdit']),
    ...mapState(['placeEditMode'])
  },

  methods: {
    placesPathDataFormatter(place) {
      return {
        value: place.id,
        label: `<i class="fas fa-${place.icon}" style="margin-right: 4px;"></i> ${place.name}`
      };
    },

    ...mapActions(['openPlaceEdit', 'closePlaceEdit'])
  },
};
</script>

<style lang="scss" scoped>
.btn-group {
  width: 100%;

  .btn {
    width: 50%;
  }
}
</style>

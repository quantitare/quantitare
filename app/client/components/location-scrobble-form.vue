<template>
  <model-form :model="model" scope="locationScrobble">
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
                :disabled="placeEditMode !== 'closed'"
              >
              </model-form-choices>
            </div>

            <div class="col-sm-3">
              <button
                v-if="placeEditMode === 'closed' && !model.placeId"
                class="btn btn-outline-success form-control"

                @click.prevent="$emit('place-edit-mode-set', 'new')"
              >
                <font-awesome-icon icon="plus"></font-awesome-icon>
              </button>

              <div v-else-if="placeEditMode === 'closed'" class="btn-group" role="group" aria-label="Place edit options">
                <button
                  type="button"
                  class="btn btn-outline-primary"

                  @click.prevent="$emit('place-edit-mode-set', 'edit')"
                >
                  <font-awesome-icon icon="pencil-alt"></font-awesome-icon>
                </button>
                <button
                  type="button"
                  class="btn btn-outline-success"

                  @click.prevent="$emit('place-edit-mode-set', 'new')"
                >
                  <font-awesome-icon icon="plus"></font-awesome-icon>
                </button>
              </div>

              <button
                v-else
                class="btn btn-outline-danger form-control"

                @click.prevent="$emit('place-edit-mode-set', 'closed')"
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
export default {
  props: {
    model: Object,

    placeEditMode: String
  },

  methods: {
    placesPathDataFormatter(place) {
      return {
        value: place.id,
        label: `<i class="fas fa-${place.icon}" style="margin-right: 4px;"></i> ${place.name}`
      };
    },
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

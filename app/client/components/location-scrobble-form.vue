<template>
  <model-form :model="locationScrobble" scope="locationScrobble">
    <template slot-scope="{ scope, model }">
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
                v-if="!placeEdit"
                class="btn btn-outline-success form-control"

                @click.prevent="$emit('toggle-place-edit', true)"
              >
                <font-awesome-icon icon="plus"></font-awesome-icon>
              </button>

              <button
                v-else
                class="btn btn-outline-danger form-control"

                @click.prevent="$emit('toggle-place-edit', false)"
              >
                <font-awesome-icon icon="times"></font-awesome-icon>
              </button>
            </div>
          </div>
        </template>
      </model-form-group>
    </template>
  </model-form>
</template>

<script>
import choices from 'components/choices';
import modelErrors from 'components/model-errors';

export default {
  components: { choices, modelErrors },

  props: {
    locationScrobble: Object,
    errors: Array,
    placeEdit: Boolean
  },

  methods: {
    placesPathDataFormatter(place) {
      return {
        value: place.id,
        label: `<i class="fas fa-${place.icon}" style="margin-right: 4px;"></i> ${place.name}`
      };
    }
  }
};
</script>

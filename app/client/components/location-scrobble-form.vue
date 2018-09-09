<template>
  <model-form :model="locationScrobble" scope="locationScrobble">
    <template slot-scope="{ scope, model }">
      <page-subheader-1>Basic info</page-subheader-1>

      <model-form-group
        attribute="name"
        :scope="scope"
        :model="model"

        :readonly="true"
      >
        Name
      </model-form-group>

      <model-form-group
        attribute="type"
        :scope="scope"
        :model="model"

        :readonly="true"
      >
        Type
      </model-form-group>

      <model-form-group
        attribute="category"
        :scope="scope"
        :model="model"

        :readonly="true"
      >
        Category
      </model-form-group>

      <page-subheader-1>Place info</page-subheader-1>

      <model-form-group
        attribute="placeId"
        :scope="scope"
        :model="model"
      >
        Choose a place

        <template slot="fields">
          <div class="row">
            <div class="col-sm-9">
              <model-form-choices
                attribute="placeId"
                :scope="scope"
                :model="model"

                :disabled="placeEdit"
                :options="[]"
                :params="{}"
              >
              </model-form-choices>
            </div>

            <div class="col-sm-3">
              <button class="btn btn-outline-success form-control" v-if="!placeEdit" @click.prevent="newCustomPlace">
                <font-awesome-icon icon="plus"></font-awesome-icon>
              </button>

              <button class="btn btn-outline-danger form-control" v-else @click.prevent="cancelCustomPlace">
                <font-awesome-icon icon="times"></font-awesome-icon>
              </button>
            </div>
          </div>
        </template>
      </model-form-group>

      <place-form :place="locationScrobble.place" :errors="[]" v-if="placeEdit">
      </place-form>
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
    errors: Array
  },

  data() {
    return {
      placeEdit: false,
    };
  },

  methods: {
    newCustomPlace() {
      this.placeEdit = true;
      this.copyLocationScrobbleDataToPlaceAttributes();
    },

    cancelCustomPlace() {
      this.placeEdit= false;
    },

    copyLocationScrobbleDataToPlaceAttributes() {
      // this.location_scrobble.place_attributes.name = this.location_scrobble.name;
    }
  }
};
</script>

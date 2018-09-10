<template>
  <model-form :model="place" scope="place">
    <template slot-scope="{ scope, model }">
      <model-form-group attribute="name" :scope="scope" :model="model">
        Name
      </model-form-group>

      <model-form-group attribute="category" :scope="scope" :model="model">
        Category

        <template slot="fields">
          <model-form-choices
            attribute="category"
            :scope="scope"
            :model="model"

            path="/locations/categories"
            :pathDataFormatter="pathDataFormatter"
          ></model-form-choices>
        </template>
      </model-form-group>

      <model-form-group :attribute="null" :scope="scope" :model="model">
        Locate by

        <template slot="fields">
          <option-toggle :options="entryModes" :active="entryMode" @select="setEntryMode">
          </option-toggle>
        </template>
      </model-form-group>

      <address-fields v-if="entryMode === 'Address'" :scope="scope" :model="model">
      </address-fields>

      <coordinates-fields v-if="entryMode === 'Coordinates'" :scope="scope" :model="model">
      </coordinates-fields>

      <model-form-group :attribute="null" :scope="scope" :model="model">
        Options

        <template slot="fields">
          <model-form-check-box class="custom-control-inline" attribute="global" :scope="scope" :model="model">
            Global
          </model-form-check-box>
        </template>
      </model-form-group>

      <place-match-options>
      </place-match-options>

      <model-form-group :attribute="null" :scope="scope" :model="model" :label="false">
        <template slot="fields">
          <model-form-submit value="Save">
          </model-form-submit>
        </template>
      </model-form-group>
    </template>
  </model-form>
</template>

<script>
const ENTRY_MODE_ADDRESS = 'Address';
const ENTRY_MODE_COORDINATES = 'Coordinates';

export default {
  props: { place: Object },

  data() {
    return {
      entryModes: [ENTRY_MODE_ADDRESS, ENTRY_MODE_COORDINATES],
      entryMode: ENTRY_MODE_ADDRESS,

      pathDataFormatter(category) {
        return {
          value: category.name,
          label: `<i class="fas fa-${category.icon}" style="margin-right: 4px;"></i> ${category.name}`
        };
      }
    };
  },

  methods: {
    setEntryMode(option) {
      this.entryMode = option;
    }
  },

  created() {
    if (this.place.latitude || this.place.longitude) this.entryMode = ENTRY_MODE_COORDINATES;
  }
};
</script>

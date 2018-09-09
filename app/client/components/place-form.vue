<template>
  <model-form :model="place" scope="place">
    <template slot-scope="{ scope, model }">
      <model-form-group
        attribute="name"
        :scope="scope"
        :model="model"
      >
        Name
      </model-form-group>

      <model-form-group
        attribute="name"
        :scope="scope"
        :model="model"
      >
        Category
      </model-form-group>

      <model-form-group
        :attribute="null"
        :scope="scope"
        :model="model"
      >
        Locate by

        <template slot="fields">
          <option-toggle
            :options="entryModes"
            :active="entryMode"

            @select="setEntryMode"
          >
          </option-toggle>
        </template>
      </model-form-group>

      <address-fields v-if="entryMode === 'Address'" :scope="scope" :model="model">
      </address-fields>

      <coordinates-fields v-if="entryMode === 'Coordinates'" :scope="scope" :model="model">
      </coordinates-fields>

      <model-form-group
        :attribute="null"
        :scope="scope"
        :model="model"
      >
        Options

        <template slot="fields">
          <model-form-check-box
            class="custom-control-inline"

            attribute="global"
            :scope="scope"
            :model="model"
          >
            Global
          </model-form-check-box>
        </template>
      </model-form-group>

      <page-subheader-2>Match options</page-subheader-2>
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
      entryMode: ENTRY_MODE_ADDRESS
    };
  },

  methods: {
    setEntryMode(option) {
      this.entryMode = option;
    }
  }
};
</script>

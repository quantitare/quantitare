<template>
  <model-form :model="place" scope="place">
    <slot name="additional-fields"></slot>

    <model-form-group attribute="name">
      Name
    </model-form-group>

    <model-form-group attribute="category">
      Category

      <template slot="fields">
        <model-form-choices attribute="category" path="/locations/categories" :pathDataFormatter="pathDataFormatter">
        </model-form-choices>
      </template>
    </model-form-group>

    <model-form-group :attribute="null">
      Locate by

      <template slot="fields">
        <option-toggle :options="entryModes" :active="entryMode" @select="setEntryMode">
        </option-toggle>
      </template>
    </model-form-group>

    <address-fields v-if="entryMode === 'Address'">
    </address-fields>

    <coordinates-fields v-if="entryMode === 'Coordinates'">
    </coordinates-fields>

    <model-form-group :attribute="null">
      Options

      <template slot="fields">
        <model-form-check-box class="custom-control-inline" attribute="global">
          Global
        </model-form-check-box>
      </template>
    </model-form-group>

    <place-match-fields>
    </place-match-fields>

    <model-form-group :attribute="null" :label="false">
      <template slot="fields">
        <model-form-submit value="Save">
        </model-form-submit>
      </template>
    </model-form-group>
  </model-form>
</template>

<script>
import { mapState } from 'vuex';

const ENTRY_MODE_ADDRESS = 'Address';
const ENTRY_MODE_COORDINATES = 'Coordinates';

export default {

  data() {
    return {
      entryModes: [ENTRY_MODE_ADDRESS, ENTRY_MODE_COORDINATES],
      entryMode: ENTRY_MODE_ADDRESS,

      pathDataFormatter(category) {
        return {
          value: category.name,
          label: `<i class="fas fa-${category.icon.name}" style="margin-right: 4px;"></i> ${category.name}`
        };
      }
    };
  },

  computed: {
    ...mapState(['place'])
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

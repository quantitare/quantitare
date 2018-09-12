<template>
  <model-form-group
    attribute="latitude"
    :scope="scope"
    :model="model"
  >
    Coordinates

    <template slot="fields">
      <div class="row">
        <div class="col-sm-6">
          <model-form-input
            attribute="latitude"
            :scope="scope"
            :model="model"

            placeholder="Latitude"
          />
        </div>

        <div class="col-sm-6">
          <model-form-input
            attribute="longitude"
            :scope="scope"
            :model="model"

            placeholder="Longitude"
          />
        </div>
      </div>
    </template>
  </model-form-group>
</template>

<script>
export default {
  props: { scope: String, model: Object }
};
</script>

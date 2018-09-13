<template>
  <model-form-group attribute="latitude">
    Coordinates

    <template slot="fields">
      <div class="row">
        <div class="col-sm-6">
          <model-form-input attribute="latitude" placeholder="Latitude" />
        </div>

        <div class="col-sm-6">
          <model-form-input attribute="longitude" placeholder="Longitude" />
        </div>
      </div>
    </template>
  </model-form-group>
</template>

<script>
import railsFormField from 'mixins/rails-form-field';

export default {
  mixins: [railsFormField]
};
</script>

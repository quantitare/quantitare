<template>
  <div>
    <model-form-group attribute="street1">
      Address

      <template slot="fields">
        <model-form-input attribute="street1" placeholder="Street line 1" />
      </template>
    </model-form-group>

    <model-form-group attribute="street2" :label="false">
      <template slot="fields">
        <model-form-input attribute="street2" placeholder="Street line 2" />
      </template>
    </model-form-group>

    <model-form-group attribute="city" :label="false">
      <template slot="fields">
        <model-form-input attribute="city" placeholder="City" />
      </template>
    </model-form-group>

    <model-form-group attribute="state" :label="false">
      <template slot="fields">
        <div class="row">
          <div class="col-sm-6">
            <model-form-input attribute="state" placeholder="State" />
          </div>

          <div class="col-sm-6">
            <model-form-input attribute="zip" placeholder="Postal code" />
          </div>
        </div>
      </template>
    </model-form-group>

    <model-form-group attribute="country" :label="false">
      <template slot="fields">
        <model-form-input attribute="country" placeholder="Country" />
      </template>
    </model-form-group>
  </div>
</template>

<script>
import railsFormField from 'mixins/rails-form-field';

export default {
  mixins: [railsFormField]
};
</script>

<template>
  <div>
    <model-form-group attribute="street1" :scope="scope" :model="model">
      Address

      <template slot="fields">
        <model-form-input
          attribute="street1"
          :scope="scope"
          :model="model"

          placeholder="Street line 1"
        />
      </template>
    </model-form-group>

    <model-form-group attribute="street2" :scope="scope" :model="model" :label="false">
      <template slot="fields">
        <model-form-input attribute="street2" :scope="scope" :model="model" placeholder="Street line 2" />
      </template>
    </model-form-group>

    <model-form-group attribute="city" :scope="scope" :model="model" :label="false">
      <template slot="fields">
        <model-form-input attribute="city" :scope="scope" :model="model" placeholder="City" />
      </template>
    </model-form-group>

    <model-form-group attribute="state" :scope="scope" :model="model" :label="false">
      <template slot="fields">
        <div class="row">
          <div class="col-sm-6">
            <model-form-input attribute="state" :scope="scope" :model="model" placeholder="State" />
          </div>

          <div class="col-sm-6">
            <model-form-input attribute="zip" :scope="scope" :model="model" placeholder="Postal code" />
          </div>
        </div>
      </template>
    </model-form-group>

    <model-form-group attribute="country" :scope="scope" :model="model" :label="false">
      <template slot="fields">
        <model-form-input attribute="country" :scope="scope" :model="model" placeholder="Country" />
      </template>
    </model-form-group>
  </div>
</template>

<script>
export default {
  props: { scope: String, model: Object }
};
</script>

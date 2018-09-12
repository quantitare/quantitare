<template>
  <div class="form-group row">
    <label class="col-sm-4 col-form-label text-right" :for="fieldId">
      <slot>{{ attribute }}</slot>
    </label>

    <div class="col-sm-8">
      <slot name="field"></slot>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    fieldId: String,
    attribute: String
  }
};
</script>

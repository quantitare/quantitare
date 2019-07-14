<template>
  <label v-if="layout === 'narrow'" class="mb-1">
    <slot></slot>
  </label>

  <label v-else class="col-sm-4 col-form-label text-right">
    <slot></slot>
  </label>
</template>

<script>
export default {
  props: {
    layout: { type: String, default: 'wide' }
  }
};
</script>

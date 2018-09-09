<template>
  <div>
    <slot></slot>
  </div>
</template>

<script>
export default {
  props: {
    location_scrobble: Object,
    readonly: Boolean
  },
};
</script>

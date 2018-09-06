<template>
  <div>
    <slot></slot>
  </div>
</template>

<script>
import choices from '../../shared/components/choices';
import modelErrors from '../../shared/components/model-errors';

export default {
  components: { choices, modelErrors },

  props: {
    location_scrobble: Object,
  },

  data() {
    return {
      locationScrobbleMetadata: {
        ready: false
      }
    };
  }
};
</script>

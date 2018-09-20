<template>
  <div class="">
    <input type="hidden" name="utf8" value="✓" />
    <input v-if="!newRecord" type="hidden" name="_method" value="patch" />
    <input type="hidden" name="authenticity_token" :value="csrf" />
  </div>
</template>

<script>
export default {
  props: {
    newRecord: {
      type: Boolean,
      default: true
    }
  },

  data() {
    return {
      csrf: document.querySelector('meta[name="csrf-token"]').getAttribute('content')
    };
  }
};
</script>

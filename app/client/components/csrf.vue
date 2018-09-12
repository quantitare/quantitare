<template>
  <div class="">
    <input name="utf8" type="hidden" value="✓">
    <input type="hidden" name="authenticity_token" :value="csrf">
  </div>
</template>

<script>
export default {
  data() {
    return {
      csrf: document.querySelector('meta[name="csrf-token"]').getAttribute('content')
    };
  }
};
</script>

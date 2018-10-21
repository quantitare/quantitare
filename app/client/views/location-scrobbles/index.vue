<template>
  <div>
    <page-header>Locations</page-header>
  </div>
</template>

<script>
import { mapGetters } from 'vuex';

export default {
  computed: {
    ...mapGetters('locationScrobbles', ['models'])
  }
};
</script>

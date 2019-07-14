<template>
  <place-scrobble-edit v-if="this.model.isPlace"></place-scrobble-edit>
  <transit-scrobble-edit v-else></transit-scrobble-edit>
</template>

<script>
import { mapGetters, mapActions } from 'vuex';

const PE_CLOSED = 'closed';
const PE_NEW = 'new';
const PE_EDIT = 'edit';
const PE_CHANGE = 'change';

const PLACE_EDIT_MODES = [PE_CLOSED, PE_NEW, PE_EDIT, PE_CHANGE];

export default {
  computed: {
    ...mapGetters('locationScrobble', ['model'])
  },

  methods: {
    ...mapActions(['cacheOriginals']),
  },

  created() {
    this.cacheOriginals();
  }
};
</script>

<style lang="scss">
</style>

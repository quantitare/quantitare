<template>
  <div>
    <page-header>
      <header-icon :icon="model.icon" />

      <span>{{ model.category }}</span>
    </page-header>

    <page-body>
      <body-section width="9">
        <location-scrobble-descriptor :model="model"></location-scrobble-descriptor>
      </body-section>
    </page-body>
  </div>
</template>

<script>
import { mapGetters } from 'vuex';

export default {
  computed: {
    ...mapGetters('locationScrobble', ['model'])
  }
};
</script>

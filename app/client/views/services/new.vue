<template>
  <service-new v-if="model.isNewRecord"></service-new>
</template>

<script>
import { mapGetters } from 'vuex'

export default {
  computed: {
    ...mapGetters('service', ['model'])
  },
}
</script>

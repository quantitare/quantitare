<template>
  <div>
    <page-header>Create a new Scrobbler</page-header>

    <div class="row pb-4">
      <div class="col-md-12">
        <scrobbler-form :available-type-options="availableTypeOptions"></scrobbler-form>
      </div>
    </div>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'

export default {
  props: {
    availableTypeOptions: { type: Array, default: () => { return [] } }
  },

  computed: {
    ...mapGetters('scrobbler', ['model'])
  }
}
</script>

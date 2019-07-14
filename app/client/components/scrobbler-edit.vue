<template>
  <div>
    <page-header>Editing your {{model.friendlyType}}</page-header>

    <div class="row pb-4">
      <div class="col-md-12">
        <scrobbler-form></scrobbler-form>
      </div>
    </div>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'

export default {
  computed: {
    ...mapGetters('scrobbler', ['model'])
  }
}
</script>

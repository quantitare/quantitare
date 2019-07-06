<template>
  <div class="row border-bottom py-4">
    <div class="col-lg-9">
      <page-subheader-2 :cozy="true">Authenticate with {{model.displayName}}</page-subheader-2>
      <service-form></service-form>
    </div>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'

export default {
  computed: {
    ...mapGetters('service', ['model']),
  }
}
</script>

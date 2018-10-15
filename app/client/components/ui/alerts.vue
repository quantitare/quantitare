<template>
  <div>
    <alert
      v-for="(alert, index) in alerts"
      v-bind:key="alert.id"

      v-bind:index="index"
      v-bind:level="alert.level"
      v-bind:content="alert.content"

      v-on:close="closeAlert(index)"
    ></alert>
  </div>
</template>

<script>
import { mapState, mapActions } from 'vuex';

export default {
  computed: {
    ...mapState('alerts', { alerts: 'items' })
  },

  methods: {
    ...mapActions('alerts', ['closeAlert'])
  }
};
</script>

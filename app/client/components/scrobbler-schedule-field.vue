<template>
  <model-form-group :attribute="fullAttribute" layout="narrow" :row="false">
    <template slot="fields">
      <model-form-choices
        :attribute="fullAttribute"
        :options="metadata.scheduleOptions"
        :params="{ shouldSort: false }"
      ></model-form-choices>
    </template>
  </model-form-group>
</template>

<script>
export default {
  props: {
    schedule: String,
    metadata: Object
  },

  computed: {
    fullAttribute() {
      return `schedules.${this.schedule}`
    }
  }
}
</script>

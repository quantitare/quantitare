<template>
  <div>
    <nav class="nav nav-pills nav-justified">
      <a :class="linkClassForScale('day')" :href="hrefForScale('day')">Day</a>
      <a :class="linkClassForScale('week')" :href="hrefForScale('week')">Week</a>
      <a :class="linkClassForScale('month')" :href="hrefForScale('month')">Month</a>
      <a :class="linkClassForScale('year')" :href="hrefForScale('year')">Year</a>
    </nav>

    <div v-for="section in sections" :key="section.name" class="row">
      <timeline-section :section="section" :scale="scale" :date="date"></timeline-section>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    scale: String,
    date: String,
    settings: Object
  },

  computed: {
    currentSettings() {
      return this.settings[this.scale]
    },

    sections() {
      return this.currentSettings.sections || []
    },
  },

  methods: {
    linkClassForScale(scale) {
      return `nav-item nav-link ${this.scale === scale ? 'active' : ''}`.trim()
    },

    hrefForScale(scale) {
      return `/timeline?scale=${scale}&date=${this.date}`
    },
  },
}
</script>

<style lang="scss" scoped>
</style>

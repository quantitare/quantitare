<template>
  <div>
    <nav class="nav nav-pills nav-justified mb-3">
      <a :class="linkClassForScale('day')" :href="hrefForScale('day')">Day</a>
      <a :class="linkClassForScale('week')" :href="hrefForScale('week')">Week</a>
      <a :class="linkClassForScale('month')" :href="hrefForScale('month')">Month</a>
      <a :class="linkClassForScale('year')" :href="hrefForScale('year')">Year</a>
    </nav>

    <div class="row mb-3 justify-content-md-center">
      <div class="col">
        <a :href="prevDateURL" class="btn btn-outline-primary btn-block">
          <font-awesome-icon icon="chevron-left"></font-awesome-icon>
        </a>
      </div>

      <div class="col-10 text-center">
        <h3>{{ displayDate }}</h3>
      </div>

      <div class="col">
        <a :href="nextDateURL" class="btn btn-outline-primary btn-block">
          <font-awesome-icon icon="chevron-right"></font-awesome-icon>
        </a>
      </div>
    </div>

    <timeline-section
      v-for="section in sections"
      :key="section.name"

      :section="section"
      :scale="scale"
      :date="date"

      class="mb-3"
    >
    </timeline-section>

    <div v-if="newSection" class="row mb-3">
      <div class="col">
        <form id="new_section_form" action="/timeline/sections" method="post" accept-charset="UTF-8">
          <csrf></csrf>
          <input type="hidden" name="section[scale]" :value="scale">

          <div class="form-row">
            <div class="col">
              <label class="sr-only" for="new_section_name">Section Name</label>
              <input
                type="text"
                name="section[name]"
                placeholder="Section Name"
                id="new_section_name"
                class="form-control form-control-lg mr-2 border-0 shadow-none px-0"

                ref="new_section_name"
              >
            </div>

            <div class="col-2">
              <input type="Submit" name="commit" value="Submit" class="btn btn-lg btn-block btn-primary">
            </div>
          </div>
        </form>
      </div>
    </div>

    <div class="row">
      <div class="col">
        <a
          v-if="!newSection"

          href="/timeline/sections/new"
          class="btn btn-outline-success btn-block"
          title="Add a section"

          @click.prevent="activateNewSection"
        >
          <font-awesome-icon icon="plus"></font-awesome-icon>
        </a>

        <a
          v-else
          href="#"
          class="btn btn-outline-danger btn-block"
          title="Cancel adding a section"

          @click.prevent="newSection = false"
        >
          <font-awesome-icon icon="times"></font-awesome-icon>
        </a>
      </div>
    </div>
  </div>
</template>

<script>
import DateAndScale from 'mixins/date-and-scale'

export default {
  mixins: [DateAndScale],

  props: {
    settings: Object
  },

  data() {
    return {
      newSection: false
    }
  },

  computed: {
    currentSettings() {
      return this.settings[this.scale]
    },

    sections() {
      return this.currentSettings.sections || []
    },

    prevDateURL() {
      return `/timeline?scale=${this.scale}&date=${this.prevDate.toISODate()}`
    },

    nextDateURL() {
      return `/timeline?scale=${this.scale}&date=${this.nextDate.toISODate()}`
    },

    displayDate() {
      switch (this.scale) {
        case 'day':
          return this.formattableDate.toFormat('cccc, d LLLL yyyy')
        case 'week':
          return `
            ${this.formattableDate.startOf('week').toFormat('d LLLL yyyy')} -
            ${this.formattableDate.endOf('week').toFormat('d LLLL yyyy')}`
        case 'month':
          return this.formattableDate.toFormat('LLLL yyyy')
        case 'year':
          return this.formattableDate.toFormat('yyyy')
        default:
          return this.date
      }
    },
  },

  methods: {
    linkClassForScale(scale) {
      return `nav-item nav-link ${this.scale === scale ? 'active' : ''}`.trim()
    },

    hrefForScale(scale) {
      return `/timeline?scale=${scale}&date=${this.date}`
    },

    activateNewSection() {
      this.newSection = true

      this.$nextTick(() => this.$refs.new_section_name.focus())
    }
  },
}
</script>

<style lang="scss" scoped>
</style>

<template>
  <div>
    <div class="col">
    </div>
  </div>
</template>

<script>
export default {
  props: {
    scale: String,
    date: String
  },

  data() {
    return {
      categories: ['device_activity'],
      scrobbles: []
    }
  },

  computed: {
    queryCategories() {
      return this.categories.join(',')
    },

    scrobblesPath() {
      return `/scrobbles?scale=${this.scale}&date=${this.date}&categories=${this.queryCategories}`
    }
  },

  created() {
    this.$http.get(this.scrobblesPath).then((response) => this.scrobbles = response.body.scrobbles)
  }
}
</script>

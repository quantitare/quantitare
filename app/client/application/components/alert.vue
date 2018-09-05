<template>
  <div v-bind:class="className" role="alert">
    {{ content }}

    <button aria-label="Close" class="close" type="button" v-on:click="close">
      <span aria-hidden="true">&times;</span>
    </button>
  </div>
</template>

<script>
export default {
  props: {
    index: Number,
    level: String,
    content: String
  },

  computed: {
    className() {
      return `alert alert-${this.level}`
    }
  },

  methods: {
    close() {
      this.$emit('close', this.id);
    }
  }
}
</script>

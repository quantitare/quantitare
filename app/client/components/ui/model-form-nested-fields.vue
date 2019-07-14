<template>
  <div><slot></slot></div>
</template>

<script>
export default {
  inject: {
    baseScope: { from: 'scope' }
  },

  provide() {
    return {
      scope: this.scope
    }
  },

  props: {
    attribute: String
  },

  computed: {
    scope() {
      return `${this.baseScope}/${this.attribute}`
    }
  }
}
</script>

<template>
  <div :style="style" class="img-icon"></div>
</template>

<script>
export default {
  props: {
    icon: Object,

    variant: {
      type: String,
      default: 'xl'
    }
  },

  computed: {
    src() {
      return this.icon[this.variant];
    },

    style() {
      return {
        'background-image': `url('${this.src}')`
      }
    }
  }
}
</script>

<style lang="scss" scoped>
.img-icon {
  display: inline-block;
  height: 1em;
  width: 1em;

  background-size: 1.25em;
  background-position: center;

  overflow: visible;
  vertical-align:  -.125em;

  // transform: scale(0.5);
  filter: invert(100%);
}
</style>

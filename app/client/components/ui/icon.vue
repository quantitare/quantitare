<template>
  <font-awesome-icon v-if="icon.type === 'fa'" :icon="icon.name"></font-awesome-icon>
  <img-icon v-else-if="icon.type === 'img'" :icon="icon" :variant="variant"></img-icon>
</template>

<script>
export default {
  props: {
    icon: Object,
    variant: {
      type: String,
      default: 'xl'
    }
  }
};
</script>

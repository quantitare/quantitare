<template>
  <div :class="`col-md-${width}`">
    <slot></slot>
  </div>
</template>

<script>
export default {
  props: ['width']
};
</script>

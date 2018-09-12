<template>
  <div :class="`col-lg-${width}`">
    <slot></slot>
  </div>
</template>

<script>
export default {
  props: ['width']
};
</script>

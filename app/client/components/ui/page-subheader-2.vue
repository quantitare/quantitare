<template>
  <h4 :class="{ 'my-3': !cozy, 'mb-3': cozy }"><slot></slot></h4>
</template>

<script>
export default {
  props: {
    cozy: false
  }
}
</script>

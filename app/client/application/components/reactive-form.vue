<template>
  <div>
    <slot></slot>
  </div>
</template>

<script>
import reactiveForm from '../mixins/reactive-form'
import baseForm from '../mixins/base-form'

export default {
  mixins: [baseForm, reactiveForm]
};
</script>

<style lang="scss">
</style>

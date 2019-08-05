<template>
  <div>
    <component
      v-for="module in section.modules"
      :key="module.component"

      :is="module.component"
      :scale="scale"
      :date="date"

      class="row"
    >
    </component>
  </div>
</template>

<script>
export default {
  props: {
    scale: String,
    date: String,
    section: Object
  }
}
</script>

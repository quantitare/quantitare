<template>
  <div class="row">
    <div v-for="total in totals" :key="total.name" class="col">
      <strong>{{ total.total }}</strong><small>{{ total.unit }}</small> {{ total.label }}
    </div>
  </div>
</template>

<script>
export default {
  props: {
    totals: Array
  },
}
</script>

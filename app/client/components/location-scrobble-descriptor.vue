<template>
  <div class="row">
    <p>
      <span v-if="model.isTransit">{{ model.distance }} &middot;</span>
      {{ model.startAtDisplay }} <i class="text-muted">to</i> {{ model.endAtDisplay }}
      &middot; {{ model.durationDisplay }}
    </p>
  </div>
</template>

<script>
export default {
  props: {
    model: Object
  }
};
</script>

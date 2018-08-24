<template>
  <p>{{ greeting }} from Vue</p>
</template>

<script>
export default {
  name: 'timeline',

  data: function() {
    return {
      greeting: 'Hello world',
    };
  },
};
</script>

<style lang="scss" scoped>
</style>

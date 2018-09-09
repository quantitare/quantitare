<template>
  <form action="#" method="post">
    <slot :scope="scope" :model="model"></slot>
  </form>
</template>

<script>
export default {
  props: {
    model: Object,
    scope: String
  }
};
</script>

<template>
  <form :id="formId" :action="formAction" method="post" accept-charset="UTF-8" :data-remote="remote">
    <csrf></csrf>
    <slot :scope="scope" :model="model"></slot>
  </form>
</template>

<script>
export default {
  props: {
    model: Object,
    scope: String,

    action: String,

    remote: {
      type: Boolean,
      default: true
    }
  },

  computed: {
    formAction() {
      return this.action || this.model.url || '#'
    },

    formId() {
      return `${_.snakeCase(this.scope)}_form`
    }
  }
};
</script>

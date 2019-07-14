<template>
  <form :id="formId" :action="formAction" method="post" accept-charset="UTF-8" :data-remote="remote">
    <csrf :new-record="model.isNewRecord"></csrf>

    <div v-if="model.errors && model.errors.base" class="offset-sm-4">
      <div v-for="error in model.errors.base" class="alert alert-danger">{{ error }}</div>
    </div>

    <slot></slot>
  </form>
</template>

<script>
export default {
  provide() {
    return {
      model: this.model,
      scope: this.scope
    }
  },

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

<template>
  <div>
    <slot></slot>
  </div>
</template>

<script>
////
// Use this component to add fields to a model-form that have a different scope. For example, if we have a model-form
// with the scope `thing` and we want to add fields under the scope `gadget` (thereby sending the following params to
// the server: `{ thing: { ...thingProperties }, gadeget: { gadgetProperties } }`), we'd use a place-form-fields
// component with a separate model and scope to shadow over the parent model-form's scope.
//
export default {
  provide() {
    return {
      model: this.model,
      scope: this.scope
    }
  },

  props: {
    model: Object,
    scope: String
  }
};
</script>

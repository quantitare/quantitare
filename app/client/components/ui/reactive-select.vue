<template>
  <form :action="action" method="post" accept-charset="UTF-8" :data-remote="remote">
    <csrf :new-record="false" />

    <select :name="name" class="custom-select" @change="submit">
      <slot></slot>
    </select>

    <input type="submit" value="Submit" class="d-none" ref="submitButton" />
  </form>
</template>

<script>
export default {
  props: {
    action: String,

    name: String,

    newRecord: {
      type: Boolean,
      default: false
    },

    remote: {
      type: Boolean,
      default: true
    }
  },

  methods: {
    submit() {
      this.$refs.submitButton.click();
    }
  }
};
</script>

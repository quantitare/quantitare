<template>
  <form :action="action" method="post" accept-charset="UTF-8" :data-remote="remote">
    <csrf :new-record="false" />

    <select :name="name" class="custom-select" @change="submit">
      <slot></slot>
    </select>

    <input type="submit" value="Submit" class="d-none" />
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
    submit(e) {
      e.target.closest('form').querySelector('input[type="submit"]').click();
    }
  }
};
</script>

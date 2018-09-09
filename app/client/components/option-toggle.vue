<template>
  <ul class="nav nav-pills nav-fill">
    <li class="nav-item" v-for="option in options">
      <a
        v-if="option === active"
        @click.prevent=""

        class="nav-link active"
        href="#"
      >
        {{ option }}
      </a>
      <a v-else @click.prevent="$emit('select', option)" class="nav-link" href="#">{{ option }}</a>
    </li>
  </ul>
</template>

<script>
export default {
  props: { options: Array, active: String }
};
</script>

<template>
  <div>
    <slot></slot>
  </div>
</template>

<script>
import choices from '../../shared/components/choices';
import modelErrors from '../../shared/components/model-errors';

export default {
  components: { choices, modelErrors },

  props: {
    scrobbler: Object,
    modelErrors: Array
  },

  data() {
    return {
      scrobblerMetadata: {
        ready: false
      }
    };
  },

  methods: {
    typeChanged(value) {
      this.scrobbler.type = value;
      this.loadTypeOptions(this.scrobbler.type);
    },

    loadTypeOptions(type) {
      this.$http.get('/scrobblers/type_data', { params: { type: type } }).then(
        (response) => {
          this.scrobblerMetadata = response.body;
        },

        (response) => {
          console.log('oops'); // TODO: Display some error message.
        }
      );
    }
  },

  mounted() {
    this.loadTypeOptions(this.scrobbler.type);
  }
};
</script>

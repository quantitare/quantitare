export default {
  watch: {
    'model': {
      handler() {
        if (!this.form || !(this.form instanceof Element)) return;

        this.form.querySelector('input[type="submit"]').click();
      },

      deep: true
    }
  }
}

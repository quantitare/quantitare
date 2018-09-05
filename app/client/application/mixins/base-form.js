export default {
  props: {
    model: Object,
    formId: String
  },

  computed: {
    form() {
      return document.getElementById(this.formId);
    }
  }
};

import _ from 'lodash';

const submitButton = document.createElement('input');
submitButton.type = 'submit';
submitButton.className = 'd-none';

export default {
  data() {
    return {
      submitButton
    };
  },

  methods: {
    submitField() {
      this.$el.appendChild(this.submitButton);
      this.submitButton.click();
      this.$el.removeChild(this.submitButton);
    }
  }
};
